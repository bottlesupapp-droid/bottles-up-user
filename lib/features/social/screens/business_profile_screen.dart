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

/// Create a business profile (a DJ, a photographer, an event group...) or edit one the person owns or manages. A venue's profile is created by the venue's business in BottlesUp Business.
class BusinessProfileScreen extends ConsumerWidget {
  const BusinessProfileScreen({super.key, this.profileId});

  /// Null to create a new one.
  final String? profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = profileId == null ? 'New business profile' : 'Edit business profile';
    if (!ref.watch(featureOnProvider(Feature.social))) {
      return Scaffold(appBar: AppBar(title: Text(title)), body: const EmptyState(icon: Icons.hourglass_empty, title: 'Coming soon', text: 'Profiles are not open yet.'));
    }
    final profiles = ref.watch(myProfilesProvider);
    return profiles.when(
      loading: () => Scaffold(appBar: AppBar(title: Text(title)), body: const Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: Text(title)),
        body: LoadFailed(message: e is SiteException ? e.message : loadFailedMessage('your profiles'), onRetry: () => ref.invalidate(myProfilesProvider)),
      ),
      data: (list) {
        SocialProfile? existing;
        for (final p in list) {
          if (p.id == profileId && p.isBusiness) existing = p;
        }
        if (profileId != null && existing == null) {
          return Scaffold(appBar: AppBar(title: Text(title)), body: const EmptyState(icon: Icons.person_off_outlined, title: 'You cannot edit this profile', text: 'It may belong to someone else, or you may no longer manage it.'));
        }
        return _Form(existing: existing);
      },
    );
  }
}

class _Form extends ConsumerStatefulWidget {
  const _Form({required this.existing});

  final SocialProfile? existing;

  @override
  ConsumerState<_Form> createState() => _FormState();
}

class _FormState extends ConsumerState<_Form> {
  late final TextEditingController _name = TextEditingController(text: widget.existing?.displayName ?? '');
  late final TextEditingController _username = TextEditingController();
  late final TextEditingController _city = TextEditingController(text: widget.existing?.city ?? '');
  late final TextEditingController _bio = TextEditingController(text: widget.existing?.bio ?? '');
  late final Map<String, TextEditingController> _links = {for (final k in socialLinkKinds) k.key: TextEditingController(text: widget.existing?.links[k.key] ?? '')};
  String _category = startableCategories.first.key;
  bool _saving = false;
  String? _problem;

  bool get _editing => widget.existing != null;

  @override
  void dispose() {
    for (final c in [_name, _username, _city, _bio, ..._links.values]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    final bio = _bio.text.trim();
    String? problem;
    if (name.isEmpty) {
      problem = 'Add the name people will see.';
    } else if (name.length > 100) {
      problem = 'The name can be 100 characters at most.';
    } else if (!_editing && (problem = usernameProblem(_username.text)) != null) {
      // set below
    } else if (bio.length > 280) {
      problem = 'Keep the description to 280 characters or fewer.';
    }
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
      final city = _city.text.trim();
      final SocialProfile saved;
      if (_editing) {
        saved = await service.updateBusiness(
          profileId: widget.existing!.id,
          name: name,
          bio: bio.isEmpty ? null : bio,
          city: city.isEmpty ? null : city,
          links: {for (final e in _links.entries) if (e.value.text.trim().isNotEmpty) e.key: e.value.text.trim()},
        );
      } else {
        saved = await service.createBusiness(category: _category, name: name, username: _username.text, bio: bio.isEmpty ? null : bio, city: city.isEmpty ? null : city);
        ref.read(selectedProfileIdProvider.notifier).state = saved.id;
      }
      ref.invalidate(myProfilesProvider);
      ref.invalidate(socialProfileProvider);
      if (!mounted) return;
      if (_editing) {
        // Opened from a link there may be nothing to go back to: show the profile instead.
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/u/${saved.handle}');
        }
      } else {
        context.pushReplacement('/u/${saved.handle}');
      }
    } on SiteException catch (e) {
      if (mounted) setState(() => _problem = e.message);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(_editing ? 'Edit business profile' : 'New business profile')),
      body: ListView(
        key: const Key('business-form'),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: [
          if (!_editing) ...[
            DropdownButtonFormField<String>(
              key: const Key('category-field'),
              initialValue: _category,
              decoration: const InputDecoration(labelText: 'What kind of profile is this?'),
              items: [for (final c in startableCategories) DropdownMenuItem(value: c.key, child: Text(c.label))],
              onChanged: (v) => setState(() => _category = v ?? _category),
            ),
            const SizedBox(height: 8),
          ] else
            ListTile(contentPadding: EdgeInsets.zero, title: Text('@${widget.existing!.handle}'), subtitle: Text(categoryLabel(widget.existing!.category))),
          TextField(key: const Key('business-name-field'), controller: _name, textCapitalization: TextCapitalization.words, textInputAction: TextInputAction.next, maxLength: 100, decoration: const InputDecoration(labelText: 'Name people will see', counterText: '')),
          const SizedBox(height: 8),
          if (!_editing) ...[UsernameField(controller: _username, fieldKey: const Key('business-username-field')), const SizedBox(height: 8)],
          TextField(key: const Key('business-city-field'), controller: _city, textCapitalization: TextCapitalization.words, maxLength: 80, decoration: const InputDecoration(labelText: 'City (optional)', counterText: '')),
          const SizedBox(height: 8),
          TextField(key: const Key('business-bio-field'), controller: _bio, maxLines: 3, maxLength: 280, decoration: const InputDecoration(labelText: 'Description (optional)')),
          if (_editing)
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: const Text('Links (optional)'),
              children: [
                for (final k in socialLinkKinds)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TextField(key: Key('business-link-${k.key}'), controller: _links[k.key], autocorrect: false, maxLength: 200, decoration: InputDecoration(labelText: k.label, hintText: k.hint, counterText: '')),
                  ),
              ],
            ),
          if (_problem != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_problem!, key: const Key('business-problem'), style: TextStyle(color: theme.colorScheme.error))),
          const SizedBox(height: 16),
          FilledButton(key: const Key('save-business'), onPressed: _saving ? null : _save, child: Text(_saving ? 'Saving...' : (_editing ? 'Save' : 'Create profile'))),
          const SizedBox(height: 8),
          Text(
            _editing ? 'The username cannot be changed.' : 'A business profile is public. You can switch between your profiles at any time.',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
