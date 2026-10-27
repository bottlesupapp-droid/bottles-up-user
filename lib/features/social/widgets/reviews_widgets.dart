import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../site/models/features.dart';
import '../../../site/models/review.dart';
import '../../../site/models/safety.dart';
import '../../../site/models/social_profile.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/post_rules.dart';
import '../../../site/site_error.dart';
import 'profile_widgets.dart';
import 'report_sheet.dart';
import 'rules_gate.dart';

/// Five stars, filled to [rating] (a half star for .5 and up is not drawn: the number beside it is the exact average).
class StarRow extends StatelessWidget {
  const StarRow({super.key, required this.rating, this.size = 18});

  final double rating;
  final double size;

  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
        for (var i = 1; i <= 5; i++) Icon(i <= rating.round() ? Icons.star : Icons.star_border, size: size, color: const Color(0xFFFFB300)),
      ]);
}

/// "4.3 (12)": the average and how many reviews, as on a card.
class RatingBadge extends StatelessWidget {
  const RatingBadge({super.key, required this.rating});

  final VenueRating rating;

  @override
  Widget build(BuildContext context) => Row(key: const Key('rating-badge'), mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.star, size: 16, color: Color(0xFFFFB300)),
        const SizedBox(width: 2),
        Text('${rating.average.toStringAsFixed(1)} (${rating.count})', style: const TextStyle(fontWeight: FontWeight.w700)),
      ]);
}

/// One review: stars, who and when, the words, and the venue's answer.
class ReviewTile extends ConsumerWidget {
  const ReviewTile({super.key, required this.review, required this.actor, required this.onChanged, this.now});

  final Review review;
  final SocialProfile actor;
  final VoidCallback onChanged;
  final DateTime? now;

  Future<void> _reply(BuildContext context, WidgetRef ref) async {
    final sent = await showModalBottomSheet<bool>(context: context, isScrollControlled: true, showDragHandle: true, builder: (_) => _ReplySheet(actor: actor, review: review));
    if (sent == true) onChanged();
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final sure = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Delete your review?'),
        actions: [
          TextButton(onPressed: () => c.pop(false), child: const Text('Cancel')),
          FilledButton(key: const Key('confirm-delete-review'), onPressed: () => c.pop(true), child: const Text('Delete')),
        ],
      ),
    );
    if (sure != true || !context.mounted) return;
    try {
      await ref.read(reviewsServiceProvider).delete(actor: actor.id, review: review.id);
      onChanged();
    } on SiteException catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> _removeReply(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(reviewsServiceProvider).deleteReply(actor: actor.id, review: review.id);
      onChanged();
    } on SiteException catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final r = review;
    return Padding(
      key: Key('review-${r.id}'),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          GestureDetector(onTap: () => context.push('/u/${r.author.handle}'), child: ProfileAvatar(profile: r.author, size: 32)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(r.author.displayName, style: const TextStyle(fontWeight: FontWeight.w700)),
              Row(children: [StarRow(rating: r.rating.toDouble(), size: 14), const SizedBox(width: 6), Text(timeAgo(r.createdAt, now ?? DateTime.now()), style: theme.textTheme.bodySmall)]),
            ]),
          ),
          if (r.isMine) TextButton(key: Key('delete-review-${r.id}'), onPressed: () => _delete(context, ref), child: const Text('Delete'))
          else
            PopupMenuButton<String>(
              key: Key('review-menu-${r.id}'),
              onSelected: (_) async {
                final result = await showReportSheet(context, actor: actor, kind: ReportKind.review, target: r.id, alsoBlock: r.author);
                if (result != null && result.blocked) onChanged();
              },
              itemBuilder: (_) => const [PopupMenuItem(value: 'report', child: Text('Report'))],
            ),
        ]),
        if (r.body != null) Padding(padding: const EdgeInsets.only(top: 6), child: Text(r.body!, key: Key('review-body-${r.id}'))),
        if (r.reply != null)
          Container(
            key: Key('reply-${r.id}'),
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: theme.colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(10)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Reply from ${r.reply!.author.displayName}', style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(r.reply!.body),
              if (r.canReply) Row(children: [TextButton(key: Key('edit-reply-${r.id}'), onPressed: () => _reply(context, ref), child: const Text('Edit')), TextButton(key: Key('remove-reply-${r.id}'), onPressed: () => _removeReply(context, ref), child: const Text('Remove'))]),
            ]),
          ),
        if (r.canReply && r.reply == null) Align(alignment: Alignment.centerLeft, child: TextButton(key: Key('reply-button-${r.id}'), onPressed: () => _reply(context, ref), child: const Text('Reply'))),
      ]),
    );
  }
}

class _ReplySheet extends ConsumerStatefulWidget {
  const _ReplySheet({required this.actor, required this.review});

  final SocialProfile actor;
  final Review review;

  @override
  ConsumerState<_ReplySheet> createState() => _ReplySheetState();
}

class _ReplySheetState extends ConsumerState<_ReplySheet> {
  late final TextEditingController _body = TextEditingController(text: widget.review.reply?.body ?? '');
  bool _busy = false;
  String? _problem;

  @override
  void dispose() {
    _body.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (_body.text.trim().isEmpty) {
      setState(() => _problem = 'Write something first.');
      return;
    }
    if (!await ensureRulesAccepted(context, ref)) return;
    setState(() {
      _busy = true;
      _problem = null;
    });
    try {
      await ref.read(reviewsServiceProvider).reply(actor: widget.actor.id, review: widget.review.id, body: _body.text);
      if (mounted) Navigator.of(context).pop(true);
    } on SiteException catch (e) {
      if (mounted) setState(() => _problem = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, MediaQuery.of(context).viewInsets.bottom + 16),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Reply to ${widget.review.author.displayName}', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          TextField(key: const Key('reply-field'), controller: _body, minLines: 2, maxLines: 5, maxLength: 1000, decoration: const InputDecoration(hintText: 'Your reply is public')),
          if (_problem != null) Text(_problem!, key: const Key('reply-problem'), style: TextStyle(color: Theme.of(context).colorScheme.error)),
          const SizedBox(height: 8),
          FilledButton(key: const Key('send-reply'), onPressed: _busy ? null : _send, child: Text(_busy ? 'Sending...' : 'Send reply')),
        ]),
      );
}

/// Write, or change, a review: stars and a few words.
Future<bool> showWriteReview(BuildContext context, {required SocialProfile actor, required ReviewKind kind, required String target, Review? existing}) async {
  final saved = await showModalBottomSheet<bool>(context: context, isScrollControlled: true, showDragHandle: true, builder: (_) => _WriteSheet(actor: actor, kind: kind, target: target, existing: existing));
  return saved == true;
}

class _WriteSheet extends ConsumerStatefulWidget {
  const _WriteSheet({required this.actor, required this.kind, required this.target, this.existing});

  final SocialProfile actor;
  final ReviewKind kind;
  final String target;
  final Review? existing;

  @override
  ConsumerState<_WriteSheet> createState() => _WriteSheetState();
}

class _WriteSheetState extends ConsumerState<_WriteSheet> {
  late int _rating = widget.existing?.rating ?? 0;
  late final TextEditingController _body = TextEditingController(text: widget.existing?.body ?? '');
  bool _busy = false;
  String? _problem;

  @override
  void dispose() {
    _body.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_rating < 1) {
      setState(() => _problem = 'Choose 1 to 5 stars.');
      return;
    }
    if (_body.text.trim().length > 1000) {
      setState(() => _problem = 'A review can be 1000 characters at most.');
      return;
    }
    if (!await ensureRulesAccepted(context, ref)) return;
    setState(() {
      _busy = true;
      _problem = null;
    });
    try {
      await ref.read(reviewsServiceProvider).save(actor: widget.actor.id, kind: widget.kind, target: widget.target, rating: _rating, body: _body.text);
      if (mounted) Navigator.of(context).pop(true);
    } on SiteException catch (e) {
      if (mounted) setState(() => _problem = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, MediaQuery.of(context).viewInsets.bottom + 16),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(widget.existing == null ? 'Write a review' : 'Change your review', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Row(children: [
            for (var i = 1; i <= 5; i++)
              IconButton(key: Key('star-$i'), tooltip: '$i star${i == 1 ? '' : 's'}', onPressed: () => setState(() => _rating = i), icon: Icon(i <= _rating ? Icons.star : Icons.star_border, color: const Color(0xFFFFB300), size: 32)),
          ]),
          TextField(key: const Key('review-field'), controller: _body, minLines: 2, maxLines: 6, maxLength: 1000, decoration: const InputDecoration(hintText: 'What was it like? (optional)')),
          if (_problem != null) Text(_problem!, key: const Key('review-problem'), style: TextStyle(color: Theme.of(context).colorScheme.error)),
          const SizedBox(height: 8),
          FilledButton(key: const Key('save-review'), onPressed: _busy ? null : _save, child: Text(_busy ? 'Saving...' : 'Save review')),
        ]),
      );
}

/// Ratings and the latest reviews of a venue or an event, on its page, with a way to write one if the person went. Nothing shows while reviews are switched off, or for someone who
/// has not set up a profile.
class ReviewsSection extends ConsumerWidget {
  const ReviewsSection({super.key, required this.kind, required this.targetId});

  final ReviewKind kind;
  final String targetId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(featureOnProvider(Feature.reviews))) return const SizedBox.shrink();
    final actor = ref.watch(actorProfileProvider);
    if (actor == null) return const SizedBox.shrink();
    final key = ReviewsKey(actor: actor.id, kind: kind, target: targetId);
    final page = ref.watch(reviewsPageProvider(key));
    final elig = ref.watch(reviewEligibilityProvider(key)).valueOrNull;
    final theme = Theme.of(context);
    void reload() {
      ref.invalidate(reviewsPageProvider(key));
      ref.invalidate(reviewEligibilityProvider(key));
      ref.invalidate(venueRatingsProvider);
    }

    return page.when(
      loading: () => const SizedBox.shrink(),
      error: (e, _) => const SizedBox.shrink(),
      data: (p) {
        Review? mine;
        for (final r in p.items) {
          if (r.isMine) mine = r;
        }
        return Padding(
          key: Key('reviews-${kind.name}-$targetId'),
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text('Reviews', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
              const Spacer(),
              if (p.summary.count > 0) ...[StarRow(rating: p.summary.average), const SizedBox(width: 6), Text('${p.summary.average.toStringAsFixed(1)} (${p.summary.count})', key: const Key('reviews-summary'), style: const TextStyle(fontWeight: FontWeight.w700))],
            ]),
            if (p.items.isEmpty) Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('No reviews yet.', key: const Key('no-reviews'), style: theme.textTheme.bodyMedium)),
            for (final r in p.items.take(3)) ReviewTile(review: r, actor: actor, onChanged: reload),
            if (p.summary.count > 3 || p.items.length > 3) TextButton(key: const Key('all-reviews'), onPressed: () => context.push('/reviews/${kind.name}/$targetId'), child: Text('See all ${p.summary.count} reviews')),
            if (elig != null && elig.eligible)
              OutlinedButton(
                key: const Key('write-review'),
                onPressed: () async {
                  if (await showWriteReview(context, actor: actor, kind: kind, target: targetId, existing: mine)) reload();
                },
                child: Text(mine == null ? 'Write a review' : 'Change your review'),
              ),
            if (elig != null && !elig.eligible && elig.reason != null && mine == null) Padding(padding: const EdgeInsets.only(top: 4), child: Text(elig.reason!, key: const Key('review-reason'), style: theme.textTheme.bodySmall)),
          ]),
        );
      },
    );
  }
}
