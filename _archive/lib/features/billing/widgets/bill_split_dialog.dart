import 'package:flutter/material.dart';
import '../models/live_bill.dart';
import '../services/live_bill_service.dart';

class BillSplitDialog extends StatefulWidget {
  final LiveBill bill;

  const BillSplitDialog({
    super.key,
    required this.bill,
  });

  @override
  State<BillSplitDialog> createState() => _BillSplitDialogState();
}

class _BillSplitDialogState extends State<BillSplitDialog> {
  final _billService = LiveBillService();
  int _numberOfPeople = 2;
  Map<String, double>? _splits;
  bool _isCalculating = false;

  Future<void> _calculateSplit() async {
    setState(() => _isCalculating = true);
    try {
      final splits = await _billService.calculateBillSplit(
        bill: widget.bill,
        numberOfPeople: _numberOfPeople,
      );
      setState(() {
        _splits = splits;
        _isCalculating = false;
      });
    } catch (e) {
      setState(() => _isCalculating = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _calculateSplit();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Split Bill'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('How many people are splitting the bill?'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _numberOfPeople > 2
                      ? () {
                          setState(() => _numberOfPeople--);
                          _calculateSplit();
                        }
                      : null,
                  icon: const Icon(Icons.remove_circle),
                ),
                Container(
                  width: 60,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '$_numberOfPeople',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _numberOfPeople < 20
                      ? () {
                          setState(() => _numberOfPeople++);
                          _calculateSplit();
                        }
                      : null,
                  icon: const Icon(Icons.add_circle),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (_isCalculating)
              const CircularProgressIndicator()
            else if (_splits != null) ...[
              const Divider(),
              const SizedBox(height: 16),
              const Text(
                'Amount per person:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              ..._splits!.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(entry.key),
                      Text(
                        '\$${entry.value.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
        FilledButton(
          onPressed: () {
            // Send payment requests to each person
            Navigator.pop(context);
          },
          child: const Text('Request Payments'),
        ),
      ],
    );
  }
}
