import 'package:flutter/material.dart';

import '../../../site/models/recognition.dart';
import '../../../site/rules/recognition_rules.dart';

/// Asks where a plaque should be posted. Answers the address, or null when the person closes it. The boxes belong to the sheet, so they live as long as its closing animation does.
Future<PlaqueAddress?> showPlaqueSheet(BuildContext context, {required String levelName, String? name}) {
  return showModalBottomSheet<PlaqueAddress>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _PlaqueSheet(levelName: levelName, name: name),
  );
}

class _PlaqueSheet extends StatefulWidget {
  const _PlaqueSheet({required this.levelName, this.name});

  final String levelName;
  final String? name;

  @override
  State<_PlaqueSheet> createState() => _PlaqueSheetState();
}

class _PlaqueSheetState extends State<_PlaqueSheet> {
  late final _recipient = TextEditingController(text: widget.name ?? '');
  final _line1 = TextEditingController();
  final _line2 = TextEditingController();
  final _city = TextEditingController();
  final _region = TextEditingController();
  final _postal = TextEditingController();
  final _country = TextEditingController();
  final _phone = TextEditingController();
  String? _wrong;

  @override
  void dispose() {
    for (final c in [_recipient, _line1, _line2, _city, _region, _postal, _country, _phone]) {
      c.dispose();
    }
    super.dispose();
  }

  void _send() {
    final address = PlaqueAddress(
      recipient: _recipient.text.trim(),
      line1: _line1.text.trim(),
      line2: _line2.text.trim().isEmpty ? null : _line2.text.trim(),
      city: _city.text.trim(),
      region: _region.text.trim().isEmpty ? null : _region.text.trim(),
      postal: _postal.text.trim(),
      country: _country.text.trim(),
      phone: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
    );
    final wrong = checkPlaqueAddress(address);
    if (wrong != null) return setState(() => _wrong = wrong);
    Navigator.pop(context, address);
  }

  Widget _field(String key, TextEditingController c, String label, {TextInputType? type, int max = 120}) =>
      Padding(padding: const EdgeInsets.only(bottom: 8), child: TextField(key: Key(key), controller: c, keyboardType: type, maxLength: max, decoration: InputDecoration(labelText: label, counterText: '')));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, MediaQuery.of(context).viewInsets.bottom + 16),
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Where should we post your ${widget.levelName} plaque?', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          const Text('We keep this address only for the parcel. It is deleted 90 days after the plaque arrives, or at once if you cancel.', key: Key('plaque-privacy')),
          const SizedBox(height: 12),
          _field('plaque-recipient', _recipient, 'Name on the parcel', max: 80),
          _field('plaque-line1', _line1, 'Street address'),
          _field('plaque-line2', _line2, 'Apartment, unit (optional)'),
          _field('plaque-city', _city, 'City', max: 80),
          _field('plaque-region', _region, 'Province or state (optional)', max: 80),
          _field('plaque-postal', _postal, 'Postal code', max: 20),
          _field('plaque-country', _country, 'Country', max: 60),
          _field('plaque-phone', _phone, 'Phone, for the courier (optional)', type: TextInputType.phone, max: 30),
          if (_wrong != null) Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(_wrong!, key: const Key('plaque-problem'), style: TextStyle(color: Theme.of(context).colorScheme.error))),
          SizedBox(width: double.infinity, child: FilledButton(key: const Key('plaque-send'), onPressed: _send, child: const Text('Ask for my plaque'))),
        ]),
      ),
    );
  }
}
