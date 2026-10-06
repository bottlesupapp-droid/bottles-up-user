import 'package:flutter/material.dart';
import '../models/refund_request.dart';
import '../services/refund_service.dart';

class RefundRequestScreen extends StatefulWidget {
  final String bookingId;
  final double originalAmount;

  const RefundRequestScreen({
    super.key,
    required this.bookingId,
    required this.originalAmount,
  });

  @override
  State<RefundRequestScreen> createState() => _RefundRequestScreenState();
}

class _RefundRequestScreenState extends State<RefundRequestScreen> {
  final _refundService = RefundService();
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  RefundReason _selectedReason = RefundReason.other;
  double _requestedAmount = 0;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _requestedAmount = widget.originalAmount;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    try {
      await _refundService.submitRefundRequest(
        bookingId: widget.bookingId,
        originalAmount: widget.originalAmount,
        requestedAmount: _requestedAmount,
        reason: _selectedReason,
        description: _descriptionController.text,
      );

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Refund request submitted successfully'),
            backgroundColor: Colors.green,
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Refund'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Booking Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Original Amount:'),
                        Text(
                          '\$${widget.originalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Refund Amount',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: _requestedAmount.toStringAsFixed(2),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixText: '\$',
                helperText: 'Enter the amount you wish to refund',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                final amount = double.tryParse(value);
                if (amount == null || amount <= 0) {
                  return 'Please enter a valid amount';
                }
                if (amount > widget.originalAmount) {
                  return 'Amount cannot exceed original payment';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _requestedAmount = double.tryParse(value) ?? 0;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Reason for Refund',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<RefundReason>(
              value: _selectedReason,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: RefundReason.values.map((reason) {
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
            const SizedBox(height: 20),
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Please provide details about your refund request...',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please provide a description';
                }
                if (value.trim().length < 20) {
                  return 'Description must be at least 20 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Refund Policy',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• Refunds are processed within 5-7 business days\n'
                    '• Partial refunds may be approved at discretion\n'
                    '• You will be notified once your request is reviewed\n'
                    '• Approved refunds return to original payment method',
                    style: TextStyle(fontSize: 12, color: Colors.blue),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _isSubmitting ? null : _submitRequest,
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Submit Refund Request'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatReason(RefundReason reason) {
    switch (reason) {
      case RefundReason.eventCancelled:
        return 'Event Cancelled';
      case RefundReason.poorExperience:
        return 'Poor Experience';
      case RefundReason.serviceIssue:
        return 'Service Issue';
      case RefundReason.billingError:
        return 'Billing Error';
      case RefundReason.personal:
        return 'Personal Reasons';
      case RefundReason.other:
        return 'Other';
    }
  }
}
