import 'package:flutter/material.dart';
import '../models/live_bill.dart';
import '../services/live_bill_service.dart';
import '../widgets/bill_split_dialog.dart';

class LiveBillScreen extends StatefulWidget {
  final String bookingId;

  const LiveBillScreen({
    super.key,
    required this.bookingId,
  });

  @override
  State<LiveBillScreen> createState() => _LiveBillScreenState();
}

class _LiveBillScreenState extends State<LiveBillScreen> {
  final _billService = LiveBillService();
  LiveBill? _bill;
  bool _isLoading = true;
  RealtimeChannel? _subscription;

  @override
  void initState() {
    super.initState();
    _loadBill();
  }

  @override
  void dispose() {
    _subscription?.unsubscribe();
    super.dispose();
  }

  Future<void> _loadBill() async {
    setState(() => _isLoading = true);
    try {
      final bill = await _billService.getLiveBill(widget.bookingId);
      setState(() {
        _bill = bill;
        _isLoading = false;
      });

      if (bill != null) {
        _subscribeToUpdates(bill.id);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _subscribeToUpdates(String billId) {
    _subscription = _billService.subscribeToBill(billId, (updatedBill) {
      setState(() => _bill = updatedBill);
    });
  }

  Future<void> _showSplitDialog() async {
    if (_bill == null) return;

    showDialog(
      context: context,
      builder: (context) => BillSplitDialog(bill: _bill!),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_bill == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Live Bill')),
        body: const Center(
          child: Text('No active bill found'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Bill'),
        actions: [
          IconButton(
            onPressed: _showSplitDialog,
            icon: const Icon(Icons.people),
            tooltip: 'Split Bill',
          ),
        ],
      ),
      body: Column(
        children: [
          // Items list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _bill!.items.length,
              itemBuilder: (context, index) {
                final item = _bill!.items[index];
                return _BillItemCard(item: item);
              },
            ),
          ),

          // Bill summary
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              children: [
                _SummaryRow(
                  label: 'Subtotal',
                  amount: _bill!.subtotal,
                ),
                const SizedBox(height: 8),
                _SummaryRow(
                  label: 'Tax (10%)',
                  amount: _bill!.tax,
                ),
                const SizedBox(height: 8),
                _SummaryRow(
                  label: 'Service Charge (15%)',
                  amount: _bill!.serviceCharge,
                ),
                const SizedBox(height: 8),
                _SummaryRow(
                  label: 'Tip',
                  amount: _bill!.tip,
                  isEditable: true,
                  onEdit: () => _showTipDialog(),
                ),
                const Divider(height: 24),
                _SummaryRow(
                  label: 'TOTAL',
                  amount: _bill!.total,
                  isTotal: true,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () {
                    // Navigate to payment
                  },
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Pay Now'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showTipDialog() async {
    final controller = TextEditingController(
      text: _bill!.tip.toStringAsFixed(2),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Tip'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Tip Amount',
            prefixText: '\$',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final tip = double.tryParse(controller.text) ?? 0;
              await _billService.updateTip(_bill!.id, tip);
              if (context.mounted) Navigator.pop(context);
              await _loadBill();
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}

class _BillItemCard extends StatelessWidget {
  final BillItem item;

  const _BillItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.itemName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.quantity}x \$${item.pricePerUnit.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  if (item.notes != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      item.notes!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Text(
              '\$${item.totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool isTotal;
  final bool isEditable;
  final VoidCallback? onEdit;

  const _SummaryRow({
    required this.label,
    required this.amount,
    this.isTotal = false,
    this.isEditable = false,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: isTotal ? 18 : 16,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (isEditable) ...[
              const SizedBox(width: 8),
              InkWell(
                onTap: onEdit,
                child: Icon(
                  Icons.edit,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ],
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isTotal ? 20 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal ? Colors.green : null,
          ),
        ),
      ],
    );
  }
}
