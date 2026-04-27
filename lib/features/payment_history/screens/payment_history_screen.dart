import 'package:flutter/material.dart';
import '../models/payment_transaction.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  final _supabase = Supabase.instance.client;

  List<PaymentTransaction> _transactions = [];
  PaymentFilter? _filter;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    setState(() => _isLoading = true);
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return;

      var query = _supabase
          .from('payment_transactions')
          .select()
          .eq('user_id', currentUser.id);

      // Apply filters
      if (_filter != null) {
        if (_filter!.dateRange != null) {
          query = query
              .gte('created_at', _filter!.dateRange!.start.toIso8601String())
              .lte('created_at', _filter!.dateRange!.end.toIso8601String());
        }
        if (_filter!.statuses != null && _filter!.statuses!.isNotEmpty) {
          query = query.in_('status', _filter!.statuses!.map((s) => s.name).toList());
        }
        if (_filter!.methods != null && _filter!.methods!.isNotEmpty) {
          query = query.in_('method', _filter!.methods!.map((m) => m.name).toList());
        }
        if (_filter!.minAmount != null) {
          query = query.gte('amount', _filter!.minAmount!);
        }
        if (_filter!.maxAmount != null) {
          query = query.lte('amount', _filter!.maxAmount!);
        }
      }

      final response = await query.order('created_at', ascending: false);

      setState(() {
        _transactions = (response as List)
            .map((item) => PaymentTransaction.fromSupabase(item as Map<String, dynamic>))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _FilterSheet(
        currentFilter: _filter,
        onApply: (filter) {
          setState(() => _filter = filter);
          _loadTransactions();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment History'),
        actions: [
          IconButton(
            icon: Badge(
              isLabelVisible: _filter != null,
              child: const Icon(Icons.filter_list),
            ),
            onPressed: _showFilterSheet,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _transactions.isEmpty
              ? _buildEmptyState()
              : _buildTransactionsList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.payment, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'No payment history',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Your payments will appear here',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList() {
    // Group by date
    final groupedTransactions = <String, List<PaymentTransaction>>{};
    for (final transaction in _transactions) {
      final dateKey = _formatDateKey(transaction.createdAt);
      groupedTransactions.putIfAbsent(dateKey, () => []).add(transaction);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: groupedTransactions.length,
      itemBuilder: (context, index) {
        final dateKey = groupedTransactions.keys.elementAt(index);
        final transactions = groupedTransactions[dateKey]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                dateKey,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
            ...transactions.map((transaction) => _PaymentCard(
                  transaction: transaction,
                  onTap: () => _showTransactionDetails(transaction),
                )),
          ],
        );
      },
    );
  }

  void _showTransactionDetails(PaymentTransaction transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _TransactionDetailsSheet(transaction: transaction),
    );
  }

  String _formatDateKey(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final transactionDate = DateTime(date.year, date.month, date.day);

    if (transactionDate == today) {
      return 'Today';
    } else if (transactionDate == yesterday) {
      return 'Yesterday';
    } else {
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    }
  }
}

class _PaymentCard extends StatelessWidget {
  final PaymentTransaction transaction;
  final VoidCallback onTap;

  const _PaymentCard({
    required this.transaction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(transaction.status).withOpacity(0.1),
          child: Icon(
            _getMethodIcon(transaction.method),
            color: _getStatusColor(transaction.status),
          ),
        ),
        title: Text(
          transaction.description ?? 'Payment',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          _formatDateTime(transaction.createdAt),
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${transaction.currency} \$${transaction.amount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            _buildStatusBadge(transaction.status),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(PaymentStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: _getStatusColor(status),
        ),
      ),
    );
  }

  Color _getStatusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.completed:
        return Colors.green;
      case PaymentStatus.failed:
        return Colors.red;
      case PaymentStatus.refunded:
      case PaymentStatus.partiallyRefunded:
        return Colors.orange;
      case PaymentStatus.processing:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getMethodIcon(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.card:
        return Icons.credit_card;
      case PaymentMethod.applePay:
        return Icons.apple;
      case PaymentMethod.googlePay:
        return Icons.g_mobiledata;
      case PaymentMethod.paypal:
        return Icons.payment;
      case PaymentMethod.bankTransfer:
        return Icons.account_balance;
      case PaymentMethod.cash:
        return Icons.money;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hour:${dateTime.minute.toString().padLeft(2, '0')} $period';
  }
}

class _FilterSheet extends StatefulWidget {
  final PaymentFilter? currentFilter;
  final Function(PaymentFilter) onApply;

  const _FilterSheet({
    this.currentFilter,
    required this.onApply,
  });

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late List<PaymentStatus> _selectedStatuses;
  late List<PaymentMethod> _selectedMethods;
  DateTimeRange? _dateRange;

  @override
  void initState() {
    super.initState();
    _selectedStatuses = widget.currentFilter?.statuses ?? [];
    _selectedMethods = widget.currentFilter?.methods ?? [];
    _dateRange = widget.currentFilter?.dateRange;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filters',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedStatuses = [];
                    _selectedMethods = [];
                    _dateRange = null;
                  });
                },
                child: const Text('Reset'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: PaymentStatus.values.map((status) {
                      final isSelected = _selectedStatuses.contains(status);
                      return FilterChip(
                        label: Text(status.name),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedStatuses.add(status);
                            } else {
                              _selectedStatuses.remove(status);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text('Payment Method', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: PaymentMethod.values.map((method) {
                      final isSelected = _selectedMethods.contains(method);
                      return FilterChip(
                        label: Text(method.name),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedMethods.add(method);
                            } else {
                              _selectedMethods.remove(method);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          FilledButton(
            onPressed: () {
              final filter = PaymentFilter(
                statuses: _selectedStatuses.isEmpty ? null : _selectedStatuses,
                methods: _selectedMethods.isEmpty ? null : _selectedMethods,
                dateRange: _dateRange,
              );
              widget.onApply(filter);
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const Text('Apply Filters'),
          ),
        ],
      ),
    );
  }
}

class _TransactionDetailsSheet extends StatelessWidget {
  final PaymentTransaction transaction;

  const _TransactionDetailsSheet({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Transaction Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _DetailRow(label: 'Amount', value: '${transaction.currency} \$${transaction.amount.toStringAsFixed(2)}'),
          _DetailRow(label: 'Status', value: transaction.status.name),
          _DetailRow(label: 'Method', value: transaction.method.name),
          if (transaction.paymentIntentId != null)
            _DetailRow(label: 'Transaction ID', value: transaction.paymentIntentId!),
          _DetailRow(label: 'Date', value: _formatDateTime(transaction.createdAt)),
          if (transaction.description != null)
            _DetailRow(label: 'Description', value: transaction.description!),
          if (transaction.refundedAmount != null)
            _DetailRow(label: 'Refunded Amount', value: '\$${transaction.refundedAmount!.toStringAsFixed(2)}'),
          const SizedBox(height: 24),
          if (transaction.receiptUrl != null)
            FilledButton.icon(
              onPressed: () {
                // Download receipt
              },
              icon: const Icon(Icons.download),
              label: const Text('Download Receipt'),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year} at $hour:${dateTime.minute.toString().padLeft(2, '0')} $period';
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey[600]),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
