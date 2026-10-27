import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/social_profile.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/profile_rules.dart';
import '../../../site/site_error.dart';
import '../widgets/profile_widgets.dart';

const int _page = 20;

/// DJs, MCs, photographers, event groups and others, best known first: narrow by what they do, where they are and their name.
class ProfessionalsScreen extends ConsumerStatefulWidget {
  const ProfessionalsScreen({super.key});

  @override
  ConsumerState<ProfessionalsScreen> createState() => _ProfessionalsScreenState();
}

class _ProfessionalsScreenState extends ConsumerState<ProfessionalsScreen> {
  final _name = TextEditingController();
  final _city = TextEditingController();
  Timer? _debounce;
  String? _category;
  final List<SocialProfile> _items = [];
  bool _loading = true;
  bool _more = false;
  bool _started = false;
  String? _error;
  String? _forActor;

  @override
  void dispose() {
    _debounce?.cancel();
    _name.dispose();
    _city.dispose();
    super.dispose();
  }

  void _typed() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      final a = ref.read(actorProfileProvider);
      if (mounted && a != null) _load(a);
    });
  }

  Future<void> _load(SocialProfile actor, {bool next = false}) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final page = await ref.read(reviewsServiceProvider).professionals(actor: actor.id, category: _category, city: _city.text, query: _name.text, limit: _page, offset: next ? _items.length : 0);
      if (!mounted) return;
      setState(() {
        if (!next) _items.clear();
        _items.addAll(page);
        _more = page.length >= _page;
      });
    } on SiteException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ActorGate(
      title: 'Professionals',
      builder: (context, actor) {
        if (!_started || _forActor != actor.id) {
          _started = true;
          _forActor = actor.id;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _load(actor);
          });
        }
        return Scaffold(
          appBar: AppBar(title: const Text('Professionals')),
          body: ListView(key: const Key('professionals-list'), padding: const EdgeInsets.fromLTRB(16, 8, 16, 96), children: [
            TextField(key: const Key('pro-name'), controller: _name, onChanged: (_) => _typed(), decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Name or username')),
            const SizedBox(height: 8),
            TextField(key: const Key('pro-city'), controller: _city, onChanged: (_) => _typed(), decoration: const InputDecoration(prefixIcon: Icon(Icons.place_outlined), hintText: 'City')),
            const SizedBox(height: 8),
            Wrap(spacing: 8, children: [
              for (final c in profileCategories)
                if (c.key != 'venue')
                  ChoiceChip(
                    key: Key('pro-category-${c.key}'),
                    label: Text(c.label),
                    selected: _category == c.key,
                    onSelected: (on) {
                      setState(() => _category = on ? c.key : null);
                      _load(actor);
                    },
                  ),
            ]),
            const SizedBox(height: 8),
            if (_error != null && _items.isEmpty) LoadFailed(message: _error!, onRetry: () => _load(actor)),
            if (_loading && _items.isEmpty) const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator())),
            if (!_loading && _error == null && _items.isEmpty) const Padding(padding: EdgeInsets.all(24), child: Center(child: Text('Nobody matches yet.', key: Key('pro-empty')))),
            for (final p in _items) ProfileTile(profile: p, onTap: () => context.push('/u/${p.handle}'), trailing: p.isMine ? null : SizedBox(width: 120, child: FollowButton(actor: actor, profile: p, compact: true))),
            if (_more) Padding(padding: const EdgeInsets.all(8), child: Center(child: OutlinedButton(key: const Key('pro-more'), onPressed: _loading ? null : () => _load(actor, next: true), child: const Text('Show more')))),
          ]),
        );
      },
    );
  }
}
