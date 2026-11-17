import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../site/models/hire.dart';
import '../../../site/models/social_profile.dart';
import '../../../site/rules/hire_rules.dart';
import '../../hiring/widgets/hiring_widgets.dart';

/// Asks the person for a time of day. Replaced in tests, which cannot tap a clock.
typedef TimePicker = Future<TimeOfDay?> Function(BuildContext context, {required TimeOfDay initial});

final timePickerProvider = Provider<TimePicker>((ref) => (context, {required initial}) => showTimePicker(context: context, initialTime: initial));

/// Whether the profile can ask a venue to host an event: an event group or a promoter.
bool isOrganizerProfile(SocialProfile p) => p.isBusiness && !p.suspended && (p.category == 'event_group' || p.category == 'promoter');

/// Whether the profile is a venue.
bool isVenueProfile(SocialProfile p) => p.isBusiness && !p.suspended && p.category == 'venue';

/// The chip that says where a hire stands, in words that never call a request a booking.
class HireChip extends StatelessWidget {
  const HireChip({super.key, required this.hire});

  final Hire hire;

  @override
  Widget build(BuildContext context) {
    final label = switch ((hire.side, hire.state)) {
      (HireSide.organizer, HireState.offered) when hire.hasLiveOffer => 'Offer to answer',
      (HireSide.venue, HireState.requested) => 'Needs your offer',
      (HireSide.venue, HireState.agreed) => 'Agreed: confirm the date',
      (HireSide.venue, HireState.offerExpired) => 'Your offer ran out',
      _ => hire.state.label,
    };
    return Chip(key: Key('hire-chip-${hire.id}'), label: Text(label), visualDensity: VisualDensity.compact);
  }
}

/// One hire in a list: who with, what kind of night and which day, and where it stands.
class HireTile extends StatelessWidget {
  const HireTile({super.key, required this.hire, required this.onTap});

  final Hire hire;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final who = hire.other?.displayName ?? 'A profile';
    return ListTile(
      key: Key('hire-${hire.id}'),
      leading: CircleAvatar(child: Icon(hire.side == HireSide.organizer ? Icons.storefront_outlined : Icons.celebration_outlined)),
      title: Text(who),
      subtitle: Text('${hire.eventType} · ${dayText(hire.eventDate)}'),
      trailing: HireChip(hire: hire),
      onTap: onTap,
    );
  }
}

/// A time "21:00" said as "9:00 PM", for a schedule line.
String scheduleTime(String? hhmmText) => hhmmText == null ? '' : timeText(hhmmText);
