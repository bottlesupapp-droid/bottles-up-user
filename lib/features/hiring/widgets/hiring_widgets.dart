import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../site/models/hiring.dart';
import '../../../site/money.dart';
import '../../../site/when.dart';

/// Asks the person for a day. Replaced in tests, which cannot tap a calendar.
typedef DayPicker = Future<DateTime?> Function(BuildContext context, {required DateTime first, required DateTime last, required DateTime initial});

final dayPickerProvider = Provider<DayPicker>((ref) => (context, {required first, required last, required initial}) => showDatePicker(context: context, firstDate: first, lastDate: last, initialDate: initial));

/// "Fri, Nov 8" for a calendar day.
String dayText(DateTime d) => formatDay(d);

/// A line of money in the booking's currency.
String cents(int c, {String currency = 'cad'}) => formatMoney(c, currency: currency);

/// The chip that says where a request stands, in the words a person reads.
class RequestChip extends StatelessWidget {
  const RequestChip({super.key, required this.request});

  final ProRequest request;

  @override
  Widget build(BuildContext context) {
    final booking = request.booking;
    final label = booking != null && request.status == RequestStatus.accepted ? booking.state.label : (request.hasOpenQuote && !request.isProviderView ? 'Quote to answer' : request.status.label);
    return Chip(key: Key('request-chip-${request.id}'), label: Text(label), visualDensity: VisualDensity.compact);
  }
}

/// One request in a list: who with, for which day, and where it stands.
class RequestTile extends StatelessWidget {
  const RequestTile({super.key, required this.request, required this.onTap});

  final ProRequest request;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final who = request.isProviderView ? (request.customer?.name ?? 'A customer') : (request.provider?.displayName ?? 'A professional');
    return ListTile(
      key: Key('request-${request.id}'),
      leading: CircleAvatar(child: Icon(request.isProviderView ? Icons.person_outline : Icons.music_note_outlined)),
      title: Text(who),
      subtitle: Text('${request.serviceTitle == null ? '' : '${request.serviceTitle} · '}${dayText(request.eventDate)}'),
      trailing: RequestChip(request: request),
      onTap: onTap,
    );
  }
}

/// A label and a value on one line.
class InfoLine extends StatelessWidget {
  const InfoLine(this.label, this.value, {super.key, this.bold = false});

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final t = bold ? Theme.of(context).textTheme.titleSmall : Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(flex: 4, child: Text(label, style: t)),
        Expanded(flex: 5, child: Text(value, textAlign: TextAlign.right, style: t)),
      ]),
    );
  }
}
