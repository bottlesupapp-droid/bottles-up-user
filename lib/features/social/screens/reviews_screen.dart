import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/review.dart';
import '../../../site/models/social_profile.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/site_error.dart';
import '../widgets/profile_widgets.dart';
import '../widgets/reviews_widgets.dart';

const int _reviewsPage = 20;

/// Every review of a venue or an event, newest first, with the stars summed up at the top.
class ReviewsScreen extends ConsumerStatefulWidget {
  const ReviewsScreen({super.key, required this.kind, required this.targetId});

  final ReviewKind kind;
  final String targetId;

  @override
  ConsumerState<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends ConsumerState<ReviewsScreen> {
  final List<Review> _items = [];
  ReviewSummary _summary = const ReviewSummary.empty();
  bool _loading = true;
  bool _more = false;
  bool _started = false;
  String? _error;
  String? _forActor;

  Future<void> _load(SocialProfile actor, {bool next = false}) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final page = await ref.read(reviewsServiceProvider).reviews(actor: actor.id, kind: widget.kind, target: widget.targetId, limit: _reviewsPage, after: next && _items.isNotEmpty ? _items.last : null);
      if (!mounted) return;
      setState(() {
        if (!next) _items.clear();
        _items.addAll(page.items);
        _summary = page.summary;
        _more = page.items.length >= _reviewsPage;
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
      title: 'Reviews',
      builder: (context, actor) {
        if (!_started || _forActor != actor.id) {
          _started = true;
          _forActor = actor.id;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _load(actor);
          });
        }
        final theme = Theme.of(context);
        return Scaffold(
          appBar: AppBar(title: const Text('Reviews')),
          body: _error != null && _items.isEmpty
              ? LoadFailed(message: _error!, onRetry: () => _load(actor))
              : _loading && _items.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(key: const Key('reviews-list'), padding: const EdgeInsets.fromLTRB(16, 8, 16, 96), children: [
                      if (_summary.count > 0)
                        Row(key: const Key('summary-header'), children: [
                          Text(_summary.average.toStringAsFixed(1), style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(children: [
                              for (var s = 5; s >= 1; s--)
                                Row(children: [
                                  SizedBox(width: 14, child: Text('$s')),
                                  const Icon(Icons.star, size: 12, color: Color(0xFFFFB300)),
                                  const SizedBox(width: 6),
                                  Expanded(child: LinearProgressIndicator(key: Key('bar-$s'), value: _summary.count == 0 ? 0 : _summary.stars[s - 1] / _summary.count, minHeight: 6)),
                                  const SizedBox(width: 6),
                                  SizedBox(width: 28, child: Text('${_summary.stars[s - 1]}', textAlign: TextAlign.end)),
                                ]),
                            ]),
                          ),
                        ]),
                      if (_items.isEmpty) const Padding(padding: EdgeInsets.all(24), child: Center(child: Text('No reviews yet.', key: Key('no-reviews')))),
                      for (final r in _items) ReviewTile(review: r, actor: actor, onChanged: () => _load(actor)),
                      if (_more) Padding(padding: const EdgeInsets.all(8), child: OutlinedButton(key: const Key('more-reviews'), onPressed: _loading ? null : () => _load(actor, next: true), child: Text(_loading ? 'Loading...' : 'Show more'))),
                    ]),
        );
      },
    );
  }
}
