import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/features.dart';
import '../../../site/models/hiring.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/hiring_rules.dart';
import '../../../site/site_error.dart';
import '../../social/widgets/profile_widgets.dart';
import '../widgets/hiring_widgets.dart';

/// The jobs the person has asked professionals for, or (as a professional) the requests they have had. What needs an answer comes first.
class HiringRequestsScreen extends ConsumerWidget {
  const HiringRequestsScreen({super.key, this.asProvider = false});

  final bool asProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = asProvider ? 'Requests for you' : 'My hiring';
    if (!ref.watch(featureOnProvider(Feature.marketplace))) {
      return Scaffold(appBar: AppBar(title: Text(title)), body: const EmptyState(icon: Icons.hourglass_empty, title: 'Coming soon', text: 'Hiring professionals is not open yet.'));
    }
    if (!asProvider) return _list(context, ref, title, ref.watch(myProRequestsProvider), () => ref.invalidate(myProRequestsProvider));
    return ActorGate(
      title: title,
      builder: (context, actor) {
        if (!isProfessional(actor)) {
          return Scaffold(appBar: AppBar(title: Text(title)), body: const EmptyState(icon: Icons.work_outline, title: 'Switch to a professional profile', text: 'Requests go to a professional profile: switch to yours from the Profile tab.'));
        }
        return _list(context, ref, title, ref.watch(proRequestsForProvider(actor.id)), () => ref.invalidate(proRequestsForProvider(actor.id)));
      },
    );
  }

  Widget _list(BuildContext context, WidgetRef ref, String title, AsyncValue<List<ProRequest>> data, VoidCallback reload) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: data.when(
        skipLoadingOnRefresh: true,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => LoadFailed(message: e is SiteException ? e.message : loadFailedMessage('the requests'), onRetry: reload),
        data: (list) {
          if (list.isEmpty) {
            return EmptyState(
              icon: Icons.work_outline,
              title: asProvider ? 'No requests yet' : 'You have not asked anyone yet',
              text: asProvider ? 'When a customer asks for a job, it shows here.' : 'Find a DJ, a photographer or another professional in Explore and ask them for a job.',
            );
          }
          bool needsAnswer(ProRequest r) => asProvider ? r.status == RequestStatus.requested : r.hasOpenQuote;
          final first = [for (final r in list) if (needsAnswer(r)) r];
          final rest = [for (final r in list) if (!needsAnswer(r)) r];
          return RefreshIndicator(
            onRefresh: () async {
              reload();
            },
            child: ListView(key: const Key('requests-list'), physics: const AlwaysScrollableScrollPhysics(), padding: const EdgeInsets.only(bottom: 40), children: [
              if (first.isNotEmpty) Padding(padding: const EdgeInsets.fromLTRB(16, 16, 16, 4), child: Text(asProvider ? 'Waiting for your quote' : 'Quotes to answer', style: Theme.of(context).textTheme.titleSmall)),
              for (final r in first) RequestTile(request: r, onTap: () => context.push('/hiring/${r.id}')),
              if (rest.isNotEmpty && first.isNotEmpty) Padding(padding: const EdgeInsets.fromLTRB(16, 16, 16, 4), child: Text('Everything else', style: Theme.of(context).textTheme.titleSmall)),
              for (final r in rest) RequestTile(request: r, onTap: () => context.push('/hiring/${r.id}')),
            ]),
          );
        },
      ),
    );
  }
}
