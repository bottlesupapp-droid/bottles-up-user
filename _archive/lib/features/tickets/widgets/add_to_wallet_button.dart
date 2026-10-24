import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/apple_wallet_service.dart';
import '../services/google_wallet_service.dart';

class AddToWalletButton extends StatefulWidget {
  final String ticketId;
  final String eventName;
  final String venueName;
  final DateTime eventDate;
  final String ticketType;
  final String qrCodeData;
  final String? seatNumber;
  final String? gateInfo;

  const AddToWalletButton({
    super.key,
    required this.ticketId,
    required this.eventName,
    required this.venueName,
    required this.eventDate,
    required this.ticketType,
    required this.qrCodeData,
    this.seatNumber,
    this.gateInfo,
  });

  @override
  State<AddToWalletButton> createState() => _AddToWalletButtonState();
}

class _AddToWalletButtonState extends State<AddToWalletButton> {
  final _appleWallet = AppleWalletService();
  final _googleWallet = GoogleWalletService();

  bool _isLoading = false;
  bool _isInWallet = false;

  @override
  void initState() {
    super.initState();
    _checkWalletStatus();
  }

  Future<void> _checkWalletStatus() async {
    try {
      final inWallet = Platform.isIOS
          ? await _appleWallet.isTicketInWallet(widget.ticketId)
          : await _googleWallet.isTicketInWallet(widget.ticketId);

      setState(() => _isInWallet = inWallet);
    } catch (e) {
      // Ignore errors
    }
  }

  Future<void> _addToWallet() async {
    setState(() => _isLoading = true);

    try {
      if (Platform.isIOS) {
        await _addToAppleWallet();
      } else if (Platform.isAndroid) {
        await _addToGoogleWallet();
      }

      setState(() => _isInWallet = true);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ticket added to wallet!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _addToAppleWallet() async {
    final passUrl = await _appleWallet.addToAppleWallet(
      ticketId: widget.ticketId,
      eventName: widget.eventName,
      venueName: widget.venueName,
      eventDate: widget.eventDate,
      ticketType: widget.ticketType,
      qrCodeData: widget.qrCodeData,
      seatNumber: widget.seatNumber,
      gateInfo: widget.gateInfo,
    );

    // Open .pkpass file URL
    final uri = Uri.parse(passUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Cannot open Apple Wallet');
    }
  }

  Future<void> _addToGoogleWallet() async {
    await _googleWallet.addToGoogleWallet(
      ticketId: widget.ticketId,
      eventName: widget.eventName,
      venueName: widget.venueName,
      eventDate: widget.eventDate,
      ticketType: widget.ticketType,
      qrCodeData: widget.qrCodeData,
      seatNumber: widget.seatNumber,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isInWallet) {
      return OutlinedButton.icon(
        onPressed: null,
        icon: Icon(_getWalletIcon()),
        label: const Text('In Wallet'),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.green,
          side: const BorderSide(color: Colors.green),
        ),
      );
    }

    return FilledButton.icon(
      onPressed: _isLoading ? null : _addToWallet,
      icon: _isLoading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Icon(_getWalletIcon()),
      label: Text(_getWalletLabel()),
      style: FilledButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
    );
  }

  IconData _getWalletIcon() {
    if (Platform.isIOS) {
      return Icons.wallet;
    } else {
      return Icons.account_balance_wallet;
    }
  }

  String _getWalletLabel() {
    if (Platform.isIOS) {
      return 'Add to Apple Wallet';
    } else {
      return 'Add to Google Wallet';
    }
  }
}

// Compact version for smaller spaces
class CompactWalletButton extends StatelessWidget {
  final String ticketId;
  final String eventName;
  final String venueName;
  final DateTime eventDate;
  final String ticketType;
  final String qrCodeData;

  const CompactWalletButton({
    super.key,
    required this.ticketId,
    required this.eventName,
    required this.venueName,
    required this.eventDate,
    required this.ticketType,
    required this.qrCodeData,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Add to Wallet',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Add this ticket to your mobile wallet for quick access',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                AddToWalletButton(
                  ticketId: ticketId,
                  eventName: eventName,
                  venueName: venueName,
                  eventDate: eventDate,
                  ticketType: ticketType,
                  qrCodeData: qrCodeData,
                ),
              ],
            ),
          ),
        );
      },
      icon: Icon(
        Platform.isIOS ? Icons.wallet : Icons.account_balance_wallet,
      ),
      tooltip: 'Add to Wallet',
    );
  }
}
