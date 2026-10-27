import 'dart:io';

/// The website's repository, checked out beside this app in the monorepo. Tests that compare the app with the website's SQL and edge functions are skipped when it is not there.
final Directory website = Directory('../bottles-up-website-main');
bool get websiteIsHere => website.existsSync();
const String websiteMissing = 'the website repo is not checked out next to this app';

String readFunction(String name) => File('${website.path}/supabase/functions/$name/index.ts').readAsStringSync();

/// A file inside the website's functions folder that is not a function of its own (`_shared/bookingNight.ts`).
String readFunctionFile(String relative) => File('${website.path}/supabase/functions/$relative').readAsStringSync();

/// The columns the website's own TypeScript types give a table (`src/types/database.ts`). Some columns exist in production but in no migration of the repository (they were made by
/// hand); the website's code and types still use them, which is the evidence they are there.
Set<String> typedColumns(String table) {
  final src = File('${website.path}/src/types/database.ts').readAsStringSync();
  final m = RegExp('\\n      $table: \\{\\n        Row: \\{([\\s\\S]*?)\\n        \\}').firstMatch(src);
  if (m == null) return {};
  return {
    for (final line in m.group(1)!.split('\n'))
      if (RegExp(r'^\s+([a-z_][a-z0-9_]*):').firstMatch(line) case final c?) c.group(1)!,
  };
}

List<File> _migrations() {
  final files = Directory('${website.path}/supabase/migrations').listSync().whereType<File>().where((f) => f.path.endsWith('.sql')).toList()..sort((a, b) => a.path.compareTo(b.path));
  return files;
}

String allMigrations() => _migrations().map((f) => f.readAsStringSync()).join('\n');

/// The columns a table has once every migration has run: the ones in its `create table`, plus every `add column`.
Set<String> columnsOf(String table) {
  final sql = allMigrations().replaceAll(RegExp(r'--[^\n]*'), '');
  final cols = <String>{};
  final create = RegExp('create\\s+table\\s+(?:if\\s+not\\s+exists\\s+)?public\\.$table\\s*\\(([\\s\\S]*?)\\n\\);', caseSensitive: false);
  for (final m in create.allMatches(sql)) {
    for (final line in m.group(1)!.split('\n')) {
      final t = line.trim();
      final first = RegExp(r'^([a-z_][a-z0-9_]*)\s+[a-z]', caseSensitive: false).firstMatch(t);
      if (first != null && !const {'constraint', 'primary', 'unique', 'check', 'foreign'}.contains(first.group(1)!.toLowerCase())) cols.add(first.group(1)!);
    }
  }
  final alter = RegExp('alter\\s+table\\s+(?:if\\s+exists\\s+)?(?:only\\s+)?public\\.$table\\s+([^;]*);', caseSensitive: false);
  for (final m in alter.allMatches(sql)) {
    for (final c in RegExp(r'add\s+column\s+(?:if\s+not\s+exists\s+)?([a-z_][a-z0-9_]*)', caseSensitive: false).allMatches(m.group(1)!)) {
      cols.add(c.group(1)!);
    }
  }
  return cols;
}

/// The migrations with their comments taken out, so a word in a comment is never mistaken for code.
String migrationCode(String fileNameContains) {
  final f = _migrations().firstWhere((f) => f.path.contains(fileNameContains));
  return f.readAsStringSync().replaceAll(RegExp(r'--[^\n]*'), '');
}

/// The parameters of a function the migrations create (`create function public.follow_set(p_actor uuid, ...)`), in order, with whether each has a default.
List<({String name, bool hasDefault})> sqlFunctionParamInfo(String name) {
  final m = RegExp('create\\s+function\\s+public\\.$name\\s*\\(([^)]*)\\)', caseSensitive: false).firstMatch(allMigrations().replaceAll(RegExp(r'--[^\n]*'), ''));
  if (m == null) throw StateError('no function $name in the migrations');
  final body = m.group(1)!.trim();
  if (body.isEmpty) return const [];
  return [
    for (final part in body.split(','))
      (name: part.trim().split(RegExp(r'\s+')).first, hasDefault: RegExp(r'\sdefault\s', caseSensitive: false).hasMatch(part)),
  ];
}

List<String> sqlFunctionParams(String name) => [for (final p in sqlFunctionParamInfo(name)) p.name];

/// The words inside the first `in ( 'a', 'b' )` list that follows [marker] in [sql].
Set<String> sqlWordsAfter(String sql, String marker) {
  final at = sql.indexOf(marker);
  if (at < 0) throw StateError('no "$marker" in the SQL');
  final open = sql.indexOf('(', at);
  final close = sql.indexOf(')', open);
  return {for (final m in RegExp("'([^']*)'").allMatches(sql.substring(open, close))) m.group(1)!};
}
