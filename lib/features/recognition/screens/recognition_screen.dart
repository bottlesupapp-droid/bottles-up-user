import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/features.dart';
import '../../../site/models/recognition.dart';
import '../../../site/models/social_profile.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/recognition_rules.dart';
import '../../../site/site_error.dart';
import '../../../site/when.dart';
import '../../hiring/widgets/hiring_dialogs.dart';
import '../../social/widgets/profile_widgets.dart';
import '../widgets/plaque_sheet.dart';
import '../widgets/rank_badge.dart';

/// Verification, rank and awards for the profile the person is acting as. BottlesUp decides every step: the person asks, BottlesUp looks, and the answer (with a reason when it is no) comes
/// back here. Nothing on this page can be bought.
class RecognitionScreen extends ConsumerStatefulWidget {
  const RecognitionScreen({super.key});

  @override
  ConsumerState<RecognitionScreen> createState() => _RecognitionScreenState();
}

class _RecognitionScreenState extends ConsumerState<RecognitionScreen> {
  bool _busy = false;

  void _say(String text) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));

  Future<void> _run(Future<void> Function() action, {String? done}) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
      if (done != null && mounted) _say(done);
    } on SiteException catch (e) {
      if (mounted) _say(e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _askToBeVerified(SocialProfile actor) async {
    final note = await showTextDialog(
      context,
      title: 'Ask to be verified',
      intro: 'BottlesUp checks that you are who you say you are. Tell us a little about yourself (optional): who you are, and where we can see your work.',
      introKey: const Key('verify-intro'),
      label: 'About you',
      confirmText: 'Send request',
      keepText: 'Not now',
      fieldKey: const Key('verify-note'),
      confirmKey: const Key('verify-send'),
      keepKey: const Key('verify-keep'),
      maxLength: maxVerificationNoteLength,
      minLines: 2,
      maxLines: 5,
      check: checkVerificationNote,
    );
    if (note == null || !mounted) return;
    await _run(() async {
      await ref.read(recognitionServiceProvider).requestVerification(profile: actor.id, note: note);
      ref.invalidate(verificationProvider(actor.id));
    }, done: 'Your request was sent. BottlesUp will look at it.');
  }

  Future<void> _askForRank(SocialProfile actor) async {
    await _run(() async {
      await ref.read(recognitionServiceProvider).requestRank(actor.id);
      ref.invalidate(rankStatusProvider(actor.id));
    }, done: 'BottlesUp will look at your followers and answer here.');
  }

  Future<void> _askForPlaque(SocialProfile actor, Award award) async {
    final address = await showPlaqueSheet(context, levelName: award.name, name: actor.displayName);
    if (address == null || !mounted) return;
    await _run(() async {
      await ref.read(recognitionServiceProvider).claimPlaque(award: award.id, address: address);
      ref.invalidate(plaquesProvider(actor.id));
    }, done: 'Your plaque was asked for. We will tell you when it is posted.');
  }

  Future<void> _cancelPlaque(SocialProfile actor, Plaque plaque) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Cancel the plaque?'),
        content: const Text('We delete the address at once. You can ask again later.'),
        actions: [
          TextButton(key: const Key('plaque-keep'), onPressed: () => Navigator.pop(c, false), child: const Text('Keep it')),
          FilledButton(key: const Key('plaque-cancel-confirm'), onPressed: () => Navigator.pop(c, true), child: const Text('Cancel it')),
        ],
      ),
    );
    if (yes != true || !mounted) return;
    await _run(() async {
      await ref.read(recognitionServiceProvider).cancelPlaque(plaque.id);
      ref.invalidate(plaquesProvider(actor.id));
    }, done: 'Cancelled. The address is deleted.');
  }

  @override
  Widget build(BuildContext context) {
    const title = 'Rank and awards';
    if (!ref.watch(featureOnProvider(Feature.ranks))) {
      return Scaffold(appBar: AppBar(title: const Text(title)), body: const EmptyState(icon: Icons.hourglass_empty, title: 'Coming soon', text: 'Verification and ranks are not open yet.'));
    }
    return ActorGate(
      title: title,
      builder: (context, actor) => Scaffold(
        appBar: AppBar(title: const Text(title)),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          _verification(context, actor),
          const SizedBox(height: 12),
          _rank(context, actor),
          const SizedBox(height: 12),
          _awards(context, actor),
          const SizedBox(height: 16),
          Text('Ranks are earned, never bought. A subscription does not give you a tick.', key: const Key('recognition-note'), style: Theme.of(context).textTheme.bodySmall),
        ]),
      ),
    );
  }

  Widget _card(String key, List<Widget> children) => Card(
        key: Key(key),
        child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children)),
      );

  Widget _failed(String message, VoidCallback retry) => Row(children: [Expanded(child: Text(message)), TextButton(onPressed: retry, child: const Text('Try again'))]);

  Widget _verification(BuildContext context, SocialProfile actor) {
    final theme = Theme.of(context);
    final info = ref.watch(verificationProvider(actor.id));
    return _card('verification-card', [
      Text('Verification', style: theme.textTheme.titleMedium),
      const SizedBox(height: 8),
      info.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _failed(e is SiteException ? e.message : loadFailedMessage('your verification'), () => ref.invalidate(verificationProvider(actor.id))),
        data: (v) {
          if (v == null) return const Text('Verification is not open yet.');
          if (v.verified) {
            return Row(children: [
              const RankBadge(rank: 'verified', size: 22),
              const SizedBox(width: 8),
              Expanded(child: Text(v.via == 'business' ? 'Verified through your business account.' : 'BottlesUp verified this profile.', key: const Key('verified-line'))),
            ]);
          }
          if (v.orgRun) {
            return const Text('This profile is verified through its business account in BottlesUp Business. It shows here once BottlesUp has checked the account.', key: Key('org-run-line'));
          }
          final r = v.request;
          if (r != null && r.isWaiting) {
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Your request is waiting. BottlesUp will look at it and answer here.', key: Key('waiting-line')),
              if (r.note != null) Padding(padding: const EdgeInsets.only(top: 6), child: Text('You wrote: ${r.note}', style: theme.textTheme.bodySmall)),
            ]);
          }
          final today = clock.now();
          final canAsk = r?.retryOn == null || !r!.retryOn!.isAfter(DateTime(today.year, today.month, today.day));
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (r != null && r.wasTurnedDown) ...[
              Text(r.state == 'revoked' ? 'BottlesUp took the tick back.' : 'BottlesUp could not verify this profile.', key: const Key('turned-down-line')),
              if (r.reason != null) Padding(padding: const EdgeInsets.only(top: 4), child: Text(r.reason!, key: const Key('turned-down-reason'))),
              if (!canAsk) Padding(padding: const EdgeInsets.only(top: 4), child: Text('You can ask again on ${formatDay(r.retryOn!)}.', key: const Key('retry-line'))),
              const SizedBox(height: 8),
            ] else
              const Padding(padding: EdgeInsets.only(bottom: 8), child: Text('A tick shows that BottlesUp has checked that this profile is who it says it is. It is free to ask, and a subscription does not give you one.')),
            FilledButton(key: const Key('ask-verify'), onPressed: _busy || !canAsk ? null : () => _askToBeVerified(actor), child: Text(r != null && r.wasTurnedDown ? 'Ask again' : 'Ask to be verified')),
          ]);
        },
      ),
    ]);
  }

  Widget _rank(BuildContext context, SocialProfile actor) {
    final theme = Theme.of(context);
    final info = ref.watch(verificationProvider(actor.id)).valueOrNull;
    final levels = ref.watch(rankLevelsProvider).valueOrNull ?? const <RankLevel>[];
    return _card('rank-card', [
      Text('Rank', style: theme.textTheme.titleMedium),
      const SizedBox(height: 8),
      // Nothing is asked about ranks until the website has said the profile is verified.
      if (info == null)
        ref.watch(verificationProvider(actor.id)).hasError ? const Text('Ranks are shown once your verification can be read.') : const Center(child: CircularProgressIndicator())
      else if (!info.verified)
        const Text('Ranks are for verified profiles. Get verified first.', key: Key('rank-needs-verified'))
      else
        ref.watch(rankStatusProvider(actor.id)).when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => _failed(e is SiteException ? e.message : loadFailedMessage('your rank'), () => ref.invalidate(rankStatusProvider(actor.id))),
          data: (s) {
            if (s == null) return const Text('Ranks are not open yet.');
            final current = levelFor(s.rank, levels);
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                RankBadge(rank: s.rank, size: 24),
                const SizedBox(width: 8),
                Expanded(child: Text(current?.name ?? 'No rank yet', key: const Key('rank-name'), style: theme.textTheme.titleSmall)),
              ]),
              const SizedBox(height: 4),
              Text('${followersText(s.followers)} followers', key: const Key('rank-followers')),
              if (s.next != null) ...[
                const SizedBox(height: 8),
                LinearProgressIndicator(key: const Key('rank-progress'), value: progressTowards(s.followers, s.next!.minFollowers), color: Color(s.next!.colour)),
                const SizedBox(height: 4),
                Text('Next: ${s.next!.name} at ${followersText(s.next!.minFollowers)} followers', key: const Key('rank-next')),
              ] else
                const Padding(padding: EdgeInsets.only(top: 8), child: Text('You hold the highest rank.', key: Key('rank-top'))),
              const SizedBox(height: 8),
              if (s.isWaiting)
                Text('BottlesUp is looking at your ${levelFor(s.pendingLevel, levels)?.name ?? 'rank'} request.', key: const Key('rank-waiting'))
              else if (s.rejectedReason != null || s.rejectedRetryOn != null)
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('BottlesUp looked and could not award it yet.', key: Key('rank-rejected')),
                  if (s.rejectedReason != null) Text(s.rejectedReason!, key: const Key('rank-rejected-reason')),
                  if (s.rejectedRetryOn != null) Text('You can ask again on ${formatDay(s.rejectedRetryOn!)}.', key: const Key('rank-retry')),
                ])
              else if (s.canRequest && s.target != null)
                FilledButton(key: const Key('ask-rank'), onPressed: _busy ? null : () => _askForRank(actor), child: Text('Ask BottlesUp to look at ${s.target!.name}'))
              else if (s.next != null)
                const Text('When you reach it, you can ask BottlesUp to look at your followers.', key: Key('rank-hint')),
              const SizedBox(height: 8),
              Text('BottlesUp checks that the followers are genuine before it awards a rank.', style: theme.textTheme.bodySmall),
            ]);
          },
        ),
    ]);
  }

  Widget _awards(BuildContext context, SocialProfile actor) {
    final theme = Theme.of(context);
    final awards = ref.watch(awardsProvider((actor: actor.id, profile: actor.id)));
    final plaques = ref.watch(plaquesProvider(actor.id)).valueOrNull ?? const <Plaque>[];
    return _card('awards-card', [
      Text('Awards', style: theme.textTheme.titleMedium),
      const SizedBox(height: 8),
      awards.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _failed(e is SiteException ? e.message : loadFailedMessage('your awards'), () => ref.invalidate(awardsProvider((actor: actor.id, profile: actor.id)))),
        data: (list) {
          if (list.isEmpty) return const Text('No award yet. When BottlesUp awards you a rank it appears here, and on your profile.', key: Key('awards-empty'));
          return Column(children: [for (final a in list) _award(context, actor, a, plaques.where((p) => p.award == a.id && !p.isCancelled).firstOrNull)]);
        },
      ),
    ]);
  }

  Widget _award(BuildContext context, SocialProfile actor, Award a, Plaque? plaque) {
    final theme = Theme.of(context);
    return Padding(
      key: Key('award-row-${a.level}'),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(Icons.verified, color: Color(a.colour)),
          const SizedBox(width: 8),
          Expanded(child: Text('${a.name}${a.awardedAt == null ? '' : ' · ${formatDay(a.awardedAt!)}'}', style: theme.textTheme.titleSmall)),
        ]),
        if (a.plaque && plaque == null)
          Align(alignment: Alignment.centerLeft, child: TextButton(key: Key('ask-plaque-${a.level}'), onPressed: _busy ? null : () => _askForPlaque(actor, a), child: const Text('Ask for a plaque'))),
        if (plaque != null) _plaque(context, actor, plaque),
      ]),
    );
  }

  Widget _plaque(BuildContext context, SocialProfile actor, Plaque p) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 32, top: 4),
      child: Column(key: Key('plaque-${p.id}'), crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(switch (p) {
          Plaque(isOpen: true) => 'Plaque asked for. We will post it soon.',
          Plaque(isOnItsWay: true) => 'Your plaque is on its way.',
          _ => 'Your plaque was delivered.',
        }, key: const Key('plaque-line')),
        if (p.carrier != null || p.tracking != null) Text('${p.carrier ?? 'Courier'}: ${p.tracking ?? 'no tracking number'}', key: const Key('plaque-tracking')),
        if (!p.addressRemoved && p.address.isNotEmpty) Text('To: ${p.address.join(', ')}', style: theme.textTheme.bodySmall),
        if (p.addressRemoved) Text('The address has been deleted.', key: const Key('plaque-removed'), style: theme.textTheme.bodySmall),
        if (p.isOpen) Align(alignment: Alignment.centerLeft, child: TextButton(key: const Key('cancel-plaque'), onPressed: _busy ? null : () => _cancelPlaque(actor, p), child: const Text('Cancel the request'))),
      ]),
    );
  }
}
