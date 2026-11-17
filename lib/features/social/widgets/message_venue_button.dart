import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../site/models/features.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/site_error.dart';

/// Is there anything to show: messages are on and the person has a profile of their own to write from.
bool canMessageVenue(WidgetRef ref) {
  if (!ref.watch(featureOnProvider(Feature.inbox))) return false;
  final actor = ref.watch(actorProfileProvider);
  return actor != null && !actor.isBusiness;
}

/// "Message the venue" on a paid booking: opens (or starts) the conversation about it with the venue's own profile. Shows only when messages are on and the person has a profile.
class MessageVenueButton extends ConsumerWidget {
  const MessageVenueButton({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(featureOnProvider(Feature.inbox))) return const SizedBox.shrink();
    final actor = ref.watch(actorProfileProvider);
    if (actor == null || actor.isBusiness) return const SizedBox.shrink();
    return Align(
      alignment: Alignment.centerLeft,
      child: OutlinedButton.icon(
        key: const Key('message-venue'),
        icon: const Icon(Icons.chat_bubble_outline),
        label: const Text('Message the venue'),
        onPressed: () async {
          final messenger = ScaffoldMessenger.of(context);
          final router = GoRouter.of(context);
          try {
            final id = await ref.read(inboxServiceProvider).startBooking(actor: actor.id, booking: bookingId);
            router.push('/inbox/$id');
          } on SiteException catch (e) {
            messenger.showSnackBar(SnackBar(content: Text(e.message)));
          }
        },
      ),
    );
  }
}
