import 'dart:io';

/// The website's repository, checked out beside this app in the monorepo. Tests that compare the app with the website's SQL and edge functions are skipped when it is not there.
final Directory website = Directory('../bottles-up-website-main');
bool get websiteIsHere => website.existsSync();
const String websiteMissing = 'the website repo is not checked out next to this app';

String readFunction(String name) => File('${website.path}/supabase/functions/$name/index.ts').readAsStringSync();

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
