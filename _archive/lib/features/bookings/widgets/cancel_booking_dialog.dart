import 'package:flutter/material.dart';
import '../../club/models/table_booking.dart';
import '../models/booking_modification.dart';
import '../services/booking_modification_service.dart';

class CancelBookingDialog extends StatefulWidget {
  final TableBooking booking;

  const CancelBookingDialog({
    super.key,
    required this.booking,
  });

  @override
  State<CancelBookingDialog> createState() => _CancelBookingDialogState();
}

class _CancelBookingDialogState extends State<CancelBookingDialog> {
  final _modificationService = BookingModificationService();
  final _notesController = TextEditingController();

  CancellationReason _selectedReason = CancellationReason.personal;
  RefundCalculation? _refundCalc;
  bool _isLoading = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadRefundCalculation();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadRefundCalculation() async {
    try {
      final calc = await _modificationService.calculateRefund(
        booking: widget.booking,
      );
      setState(() {
        _refundCalc = calc;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _submitCancellation() async {
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    try {
      await _modificationService.requestCancellation(
        bookingId: widget.booking.id,
        reason: _selectedReason,
        userNotes: _notesController.text.isNotEmpty
            ? _notesController.text
            : null,
      );

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cancellation request submitted'),
          ),
        );
      }
    } catch (e) {
      setState(() => _isSubmitting = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cancel Booking'),
      content: _isLoading
          ? const SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Refund information
                  if (_refundCalc != null) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _refundCalc!.isRefundable
                            ? Colors.green.withOpacity(0.1)
                            : Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _refundCalc!.isRefundable
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _refundCalc!.isRefundable
                                    ? Icons.check_circle
                                    : Icons.warning,
                                color: _refundCalc!.isRefundable
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _refundCalc!.message ?? 'Refund information',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _RefundRow(
                            label: 'Original amount',
                            value: '\$${_refundCalc!.originalAmount.toStringAsFixed(2)}',
                          ),
                          _RefundRow(
                            label: 'Refund (${_refundCalc!.refundPercentage.toInt()}%)',
                            value: '\$${_refundCalc!.refundAmount.toStringAsFixed(2)}',
                          ),
                          if (_refundCalc!.cancellationFee > 0)
                            _RefundRow(
                              label: 'Cancellation fee',
                              value: '-\$${_refundCalc!.cancellationFee.toStringAsFixed(2)}',
                              valueColor: Colors.red,
                            ),
                          const Divider(),
                          _RefundRow(
                            label: 'Net refund',
                            value: '\$${_refundCalc!.netRefund.toStringAsFixed(2)}',
                            isTotal: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Cancellation reason
                  const Text(
                    'Reason for cancellation',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<CancellationReason>(
                    value: _selectedReason,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    items: CancellationReason.values.map((reason) {
                      return DropdownMenuItem(
                        value: reason,
                        child: Text(_formatReason(reason)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedReason = value);
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // Additional notes
                  const Text(
                    'Additional notes (optional)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Any additional information...',
                      contentPadding: EdgeInsets.all(12),
                    ),
                  ),
                ],
              ),
            ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
          child: const Text('Keep Booking'),
        ),
        FilledButton(
          onPressed: _isSubmitting || _isLoading ? null : _submitCancellation,
          style: FilledButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          child: _isSubmitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Cancel Booking'),
        ),
      ],
    );
  }

  String _formatReason(CancellationReason reason) {
    switch (reason) {
      case CancellationReason.personal:
        return 'Personal reasons';
      case CancellationReason.weather:
        return 'Weather concerns';
      case CancellationReason.health:
        return 'Health issues';
      case CancellationReason.foundBetter:
        return 'Found better option';
      case CancellationReason.tooExpensive:
        return 'Too expensive';
      case CancellationReason.eventChanged:
        return 'Event changed';
      case CancellationReason.other:
        return 'Other';
    }
  }
}

class _RefundRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isTotal;

  const _RefundRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              fontSize: isTotal ? 16 : 14,
              color: valueColor ?? (isTotal ? Colors.green : null),
            ),
          ),
        ],
      ),
    );
  }
}
