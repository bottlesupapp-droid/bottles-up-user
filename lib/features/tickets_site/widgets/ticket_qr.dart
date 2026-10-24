import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// A ticket's QR code: the ticket code itself, on white so a camera can read it (the door scans exactly this text), with the code written under it.
class TicketQr extends StatelessWidget {
  const TicketQr({super.key, required this.code, this.size = 200});

  final String code;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
          child: QrImageView(key: const Key('ticket-qr'), data: code, size: size, backgroundColor: Colors.white, eyeStyle: const QrEyeStyle(color: Colors.black, eyeShape: QrEyeShape.square), dataModuleStyle: const QrDataModuleStyle(color: Colors.black, dataModuleShape: QrDataModuleShape.square)),
        ),
        const SizedBox(height: 10),
        SelectableText(code, key: const Key('ticket-code'), style: Theme.of(context).textTheme.titleLarge?.copyWith(letterSpacing: 3, fontWeight: FontWeight.w700)),
      ],
    );
  }
}
