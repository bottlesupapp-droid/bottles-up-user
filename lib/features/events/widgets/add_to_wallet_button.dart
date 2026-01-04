import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

import '../models/event.dart';
import '../models/event_rsvp.dart';
import '../models/wallet_pass.dart';
import '../providers/wallet_pass_provider.dart';

/// Widget that displays an "Add to Apple Wallet" button
class AddToWalletButton extends ConsumerStatefulWidget {
  final String eventId;
  final String bookingId;
  final String passType; // 'rsvp' or 'table_booking'
  final Event event;
  final EventRSVP? rsvp;
  final EventTableBooking? tableBooking;
  final String? tableName;

  const AddToWalletButton({
    super.key,
    required this.eventId,
    required this.bookingId,
    required this.passType,
    required this.event,
    this.rsvp,
    this.tableBooking,
    this.tableName,
  });

  @override
  ConsumerState<AddToWalletButton> createState() => _AddToWalletButtonState();
}

class _AddToWalletButtonState extends ConsumerState<AddToWalletButton> {
  bool _isLoading = false;
  WalletPass? _existingPass;

  @override
  void initState() {
    super.initState();
    _checkExistingPass();
  }

  Future<void> _checkExistingPass() async {
    final pass = await ref.read(walletPassServiceProvider).getPassForBooking(
          bookingId: widget.bookingId,
          passType: widget.passType,
        );
    if (mounted) {
      setState(() {
        _existingPass = pass;
      });
    }
  }

  Future<void> _generateAndAddToWallet() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final service = ref.read(walletPassServiceProvider);
      WalletPass? pass;

      // Generate pass based on type
      if (widget.passType == 'rsvp' && widget.rsvp != null) {
        pass = await service.generateRsvpPass(
          eventId: widget.eventId,
          rsvpId: widget.bookingId,
          event: widget.event,
          rsvp: widget.rsvp!,
        );
      } else if (widget.passType == 'table_booking' &&
          widget.tableBooking != null &&
          widget.tableName != null) {
        pass = await service.generateTableBookingPass(
          eventId: widget.eventId,
          bookingId: widget.bookingId,
          event: widget.event,
          booking: widget.tableBooking!,
          tableName: widget.tableName!,
        );
      }

      if (pass != null && pass.passUrl != null) {
        setState(() {
          _existingPass = pass;
        });

        // Download and share the pass file
        if (Platform.isIOS) {
          final filePath = await service.downloadPassFile(pass.passUrl!);

          // Share the .pkpass file which iOS will recognize and offer to add to Wallet
          await Share.shareXFiles(
            [XFile(filePath)],
            text: 'Add this event to your Apple Wallet',
          );

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Tap the shared file to add to Apple Wallet'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Apple Wallet is only available on iOS'),
                backgroundColor: Colors.orange,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate wallet pass: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _shareExistingPass() async {
    if (_existingPass?.passUrl == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final service = ref.read(walletPassServiceProvider);
      final filePath = await service.downloadPassFile(_existingPass!.passUrl!);

      await Share.shareXFiles(
        [XFile(filePath)],
        text: 'Your event ticket',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to share wallet pass: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Only show on iOS
    if (!Platform.isIOS) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: _existingPass != null
          ? OutlinedButton.icon(
              onPressed: _isLoading ? null : _shareExistingPass,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Image.asset(
                      'assets/wallet_icon.png',
                      width: 24,
                      height: 24,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.wallet);
                      },
                    ),
              label: const Text(
                'View in Apple Wallet',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: Colors.black, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            )
          : ElevatedButton(
              onPressed: _isLoading ? null : _generateAndAddToWallet,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/wallet_icon.png',
                          width: 24,
                          height: 24,
                          color: Colors.white,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.wallet,
                              color: Colors.white,
                            );
                          },
                        ),
                        const Gap(8),
                        const Text(
                          'Add to Apple Wallet',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
            ),
    );
  }
}
