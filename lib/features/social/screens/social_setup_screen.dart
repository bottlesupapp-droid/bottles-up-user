import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/features.dart';
import '../../../site/models/social_profile.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/profile_rules.dart';
import '../../../site/site_error.dart';
import '../widgets/username_field.dart';

/// Set up, or change, the person's own profile: name, username, city, a few words about them, links, what they like, and whether anyone can follow them or only people they approve.
class SocialSetupScreen extends ConsumerWidget {
  const SocialSetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(featureOnProvider(Feature.social))) {
      return Scaffold(appBar: AppBar(title: const Text('Your profile')), body: const EmptyState(icon: Icons.hourglass_empty, title: 'Coming soon', text: 'Profiles are not open yet.'));
    }
    final profiles = ref.watch(myProfilesProvider);
    return profiles.when(
      loading: () => Scaffold(appBar: AppBar(title: const Text('Your profile')), body: const Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: const Text('Your profile')),
        body: LoadFailed(message: e is SiteException ? e.message : loadFailedMessage('your profile'), onRetry: () => ref.invalidate(myProfilesProvider)),
      ),
      data: (list) {
        SocialProfile? own;
        for (final p in list) {
          if (!p.isBusiness) own = p;
        }
        return _SetupForm(existing: own);
      },
    );
  }
}

class _SetupForm extends ConsumerStatefulWidget {
  const _SetupForm({required this.existing});

  final SocialProfile? existing;

  @override
  ConsumerState<_SetupForm> createState() => _SetupFormState();
}

class _SetupFormState extends ConsumerState<_SetupForm> {
  late final TextEditingController _name;
  late final TextEditingController _username;
  late final TextEditingController _city;
  late final TextEditingController _bio;
  late final TextEditingController _interest = TextEditingController();
  late final Map<String, TextEditingController> _links;
  late List<String> _interests;
  late bool _private;
  bool _saving = false;
  String? _problem;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    final account = ref.read(accountProvider).valueOrNull;
    _name = TextEditingController(text: e?.displayName ?? account?.name ?? '');
    _username = TextEditingController(text: e?.handle ?? '');
    _city = TextEditingController(text: e?.city ?? '');
    _bio = TextEditingController(text: e?.bio ?? '');
    _links = {for (final k in socialLinkKinds) k.key: TextEditingController(text: e?.links[k.key] ?? '')};
    _interests = [...?e?.interests];
    _private = e?.isPrivate ?? false;
  }

  @override
  void dispose() {
    for (final c in [_name, _username, _city, _bio, _interest, ..._links.values]) {
      c.dispose();
    }
    super.dispose();
  }

  void _addInterest() {
    final typed = _interest.text;
    if (typed.trim().isEmpty) return;
    final r = cleanInterests([..._interests, typed]);
    if (r.problem != null) {
      setState(() => _problem = r.problem);
      return;
    }
    setState(() {
      _interests = r.interests;
      _interest.clear();
      _problem = null;
    });
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    final city = _city.text.trim();
    final bio = _bio.text.trim();
    String? problem;
    if (name.isEmpty) {
      problem = 'Add your name.';
    } else if (name.length > 100) {
      problem = 'Your name can be 100 characters at most.';
    } else if ((problem = usernameProblem(_username.text)) != null) {
      // set below
    } else if (city.isEmpty) {
      problem = 'Add your city.';
    } else if (bio.length > 280) {
      problem = 'Keep your bio to 280 characters or fewer.';
    }
    final interests = cleanInterests(_interests);
    problem ??= interests.problem;
    if (problem != null) {
      setState(() => _problem = problem);
      return;
    }
    setState(() {
      _saving = true;
      _problem = null;
    });
    final service = ref.read(socialProfilesServiceProvider);
    try {
      await service.saveDetails(
        name: name,
        username: _username.text,
        city: city,
        bio: bio.isEmpty ? null : bio,
        links: {for (final e in _links.entries) if (e.value.text.trim().isNotEmpty) e.key: e.value.text.trim()},
      );
      await service.savePersonal(isPrivate: _private, interests: interests.interests);
      ref.invalidate(myProfilesProvider);
      ref.invalidate(socialProfileProvider);
      ref.invalidate(accountProvider);
      if (!mounted) return;
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/home');
      }
    } on SiteException catch (e) {
      if (mounted) setState(() => _problem = e.message);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // The account's name arrives a moment after the screen opens; it fills the box only if the person has not typed one.
    ref.listen(accountProvider, (_, next) {
      final name = next.valueOrNull?.name;
      if (widget.existing == null && name != null && name.isNotEmpty && _name.text.isEmpty) _name.text = name;
    });
    final theme = Theme.of(context);
    final editing = widget.existing != null;
    return Scaffold(
      appBar: AppBar(title: Text(editing ? 'Edit profile' : 'Set up your profile')),
      body: ListView(
        key: const Key('setup-form'),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: [
          TextField(key: const Key('name-field'), controller: _name, textCapitalization: TextCapitalization.words, textInputAction: TextInputAction.next, maxLength: 100, decoration: const InputDecoration(labelText: 'Name', counterText: '')),
          const SizedBox(height: 8),
          UsernameField(controller: _username),
          const SizedBox(height: 8),
          TextField(key: const Key('city-field'), controller: _city, textCapitalization: TextCapitalization.words, textInputAction: TextInputAction.next, maxLength: 80, decoration: const InputDecoration(labelText: 'City', counterText: '')),
          const SizedBox(height: 8),
          TextField(key: const Key('bio-field'), controller: _bio, maxLines: 3, maxLength: 280, decoration: const InputDecoration(labelText: 'Bio (optional)')),
          const SizedBox(height: 16),
          Text('What you like', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Wrap(spacing: 8, children: [
            for (final i in _interests) InputChip(key: Key('interest-$i'), label: Text(i), onDeleted: () => setState(() => _interests = [..._interests]..remove(i))),
          ]),
          Row(children: [
            Expanded(child: TextField(key: const Key('interest-field'), controller: _interest, maxLength: 30, onSubmitted: (_) => _addInterest(), decoration: const InputDecoration(hintText: 'afrobeats, rooftops, brunch...', counterText: ''))),
            IconButton(key: const Key('add-interest'), tooltip: 'Add', icon: const Icon(Icons.add_circle_outline), onPressed: _addInterest),
          ]),
          const SizedBox(height: 16),
          SwitchListTile(
            key: const Key('private-switch'),
            contentPadding: EdgeInsets.zero,
            value: _private,
            onChanged: (v) => setState(() => _private = v),
            title: const Text('Private account'),
            subtitle: Text(_private ? 'Only people you approve can follow you and see your posts.' : 'Anyone can follow you and see your posts.'),
          ),
          const SizedBox(height: 8),
          ExpansionTile(
            key: const Key('links-tile'),
            tilePadding: EdgeInsets.zero,
            title: const Text('Links (optional)'),
            children: [
              for (final k in socialLinkKinds)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TextField(key: Key('link-field-${k.key}'), controller: _links[k.key], autocorrect: false, maxLength: 200, decoration: InputDecoration(labelText: k.label, hintText: k.hint, counterText: '')),
                ),
            ],
          ),
          if (_problem != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_problem!, key: const Key('setup-problem'), style: TextStyle(color: theme.colorScheme.error))),
          const SizedBox(height: 16),
          FilledButton(key: const Key('save-profile'), onPressed: _saving ? null : _save, child: Text(_saving ? 'Saving...' : (editing ? 'Save' : 'Create my profile'))),
          const SizedBox(height: 8),
          Text('Your photo and phone number are changed in Account details.', style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
