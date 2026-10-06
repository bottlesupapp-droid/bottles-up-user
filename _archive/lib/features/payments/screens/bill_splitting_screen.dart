import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/bill_split.dart';
import '../services/bill_split_service.dart';

class BillSplittingScreen extends StatefulWidget {
  final String bookingId;
  final double totalAmount;
  final List<String>? participantIds;

  const BillSplittingScreen({
    super.key,
    required this.bookingId,
    required this.totalAmount,
    this.participantIds,
  });

  @override
  State<BillSplittingScreen> createState() => _BillSplittingScreenState();
}

class _BillSplittingScreenState extends State<BillSplittingScreen> {
  final _billSplitService = BillSplitService();
  BillSplit? _billSplit;
  bool _isLoading = true;
  SplitMethod _splitMethod = SplitMethod.equal;
  int _equalSplits = 2;
  final Map<String, double> _customAmounts = {};
  final Map<String, int> _percentages = {};

  @override
  void initState() {
    super.initState();
    _loadOrCreateBillSplit();
  }

  Future<void> _loadOrCreateBillSplit() async {
    setState(() => _isLoading = true);
    try {
      final billSplit = await _billSplitService.getBillSplitForBooking(
        widget.bookingId,
      );

      if (billSplit != null) {
        setState(() {
          _billSplit = billSplit;
          _splitMethod = billSplit.splitMethod;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _createBillSplit() async {
    try {
      List<BillParticipant> participants;

      switch (_splitMethod) {
        case SplitMethod.equal:
          final amountPerPerson = widget.totalAmount / _equalSplits;
          participants = List.generate(
            _equalSplits,
            (index) => BillParticipant(
              id: 'temp_$index',
              billSplitId: '',
              userId: widget.participantIds != null && index < widget.participantIds!.length
                  ? widget.participantIds![index]
                  : null,
              userName: 'Person ${index + 1}',
              amountOwed: amountPerPerson,
              status: ParticipantStatus.pending,
              createdAt: DateTime.now(),
            ),
          );
          break;

        case SplitMethod.custom:
          participants = _customAmounts.entries.map((entry) {
            return BillParticipant(
              id: 'temp_${entry.key}',
              billSplitId: '',
              userId: entry.key,
              userName: entry.key,
              amountOwed: entry.value,
              status: ParticipantStatus.pending,
              createdAt: DateTime.now(),
            );
          }).toList();
          break;

        case SplitMethod.percentage:
          participants = _percentages.entries.map((entry) {
            final amount = widget.totalAmount * (entry.value / 100);
            return BillParticipant(
              id: 'temp_${entry.key}',
              billSplitId: '',
              userId: entry.key,
              userName: entry.key,
              amountOwed: amount,
              status: ParticipantStatus.pending,
              createdAt: DateTime.now(),
            );
          }).toList();
          break;

        case SplitMethod.itemized:
          // Handled separately in itemized screen
          participants = [];
          break;
      }

      final billSplit = await _billSplitService.createBillSplit(
        bookingId: widget.bookingId,
        totalAmount: widget.totalAmount,
        splitMethod: _splitMethod,
        participants: participants.map((p) => {
          'user_id': p.userId,
          'user_name': p.userName,
          'amount_owed': p.amountOwed,
        }).toList(),
      );

      setState(() => _billSplit = billSplit);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bill split created successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create bill split: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Split Bill'),
        actions: [
          if (_billSplit != null)
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: _sharePaymentLinks,
            ),
        ],
      ),
      body: _billSplit == null ? _buildSplitSetup() : _buildSplitSummary(),
      bottomNavigationBar: _billSplit == null
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: _canCreateSplit() ? _createBillSplit : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Create Split'),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildSplitSetup() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total amount
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Amount',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '\$${widget.totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Split method selector
          const Text(
            'Split Method',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildMethodSelector(),
          const SizedBox(height: 24),

          // Method-specific UI
          _buildMethodSpecificUI(),
        ],
      ),
    );
  }

  Widget _buildMethodSelector() {
    return Wrap(
      spacing: 8,
      children: [
        ChoiceChip(
          label: const Text('Equal Split'),
          selected: _splitMethod == SplitMethod.equal,
          onSelected: (selected) {
            setState(() => _splitMethod = SplitMethod.equal);
          },
        ),
        ChoiceChip(
          label: const Text('Custom Amounts'),
          selected: _splitMethod == SplitMethod.custom,
          onSelected: (selected) {
            setState(() => _splitMethod = SplitMethod.custom);
          },
        ),
        ChoiceChip(
          label: const Text('Percentage'),
          selected: _splitMethod == SplitMethod.percentage,
          onSelected: (selected) {
            setState(() => _splitMethod = SplitMethod.percentage);
          },
        ),
        ChoiceChip(
          label: const Text('Itemized'),
          selected: _splitMethod == SplitMethod.itemized,
          onSelected: (selected) {
            setState(() => _splitMethod = SplitMethod.itemized);
          },
        ),
      ],
    );
  }

  Widget _buildMethodSpecificUI() {
    switch (_splitMethod) {
      case SplitMethod.equal:
        return _buildEqualSplitUI();
      case SplitMethod.custom:
        return _buildCustomAmountsUI();
      case SplitMethod.percentage:
        return _buildPercentageUI();
      case SplitMethod.itemized:
        return _buildItemizedUI();
    }
  }

  Widget _buildEqualSplitUI() {
    final amountPerPerson = widget.totalAmount / _equalSplits;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Number of people',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton.filled(
                  icon: const Icon(Icons.remove),
                  onPressed: _equalSplits > 2
                      ? () => setState(() => _equalSplits--)
                      : null,
                ),
                Text(
                  '$_equalSplits people',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton.filled(
                  icon: const Icon(Icons.add),
                  onPressed: _equalSplits < 20
                      ? () => setState(() => _equalSplits++)
                      : null,
                ),
              ],
            ),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Amount per person'),
                Text(
                  '\$${amountPerPerson.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomAmountsUI() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Custom Amounts',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle),
                  onPressed: _addCustomParticipant,
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_customAmounts.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Tap + to add participants'),
                ),
              )
            else
              ..._customAmounts.entries.map((entry) {
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(entry.key[0].toUpperCase()),
                  ),
                  title: Text(entry.key),
                  trailing: SizedBox(
                    width: 100,
                    child: TextField(
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        prefixText: '\$',
                        isDense: true,
                      ),
                      controller: TextEditingController(
                        text: entry.value.toStringAsFixed(2),
                      ),
                      onChanged: (value) {
                        final amount = double.tryParse(value) ?? 0;
                        setState(() => _customAmounts[entry.key] = amount);
                      },
                    ),
                  ),
                );
              }).toList(),
            const Divider(height: 24),
            _buildAmountValidation(),
          ],
        ),
      ),
    );
  }

  Widget _buildPercentageUI() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Percentage Split',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle),
                  onPressed: _addPercentageParticipant,
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_percentages.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Tap + to add participants'),
                ),
              )
            else
              ..._percentages.entries.map((entry) {
                final amount = widget.totalAmount * (entry.value / 100);
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(entry.key[0].toUpperCase()),
                  ),
                  title: Text(entry.key),
                  subtitle: Text('\$${amount.toStringAsFixed(2)}'),
                  trailing: SizedBox(
                    width: 100,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        suffixText: '%',
                        isDense: true,
                      ),
                      controller: TextEditingController(
                        text: entry.value.toString(),
                      ),
                      onChanged: (value) {
                        final percent = int.tryParse(value) ?? 0;
                        setState(() => _percentages[entry.key] = percent);
                      },
                    ),
                  ),
                );
              }).toList(),
            const Divider(height: 24),
            _buildPercentageValidation(),
          ],
        ),
      ),
    );
  }

  Widget _buildItemizedUI() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.receipt_long, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Itemized Split',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Split bill by individual items ordered',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Set Up Itemized Split'),
              onPressed: () {
                // Navigate to itemized split screen
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountValidation() {
    final totalCustom = _customAmounts.values.fold<double>(
      0,
      (sum, amount) => sum + amount,
    );
    final difference = widget.totalAmount - totalCustom;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Total assigned: \$${totalCustom.toStringAsFixed(2)}',
          style: TextStyle(
            color: difference.abs() < 0.01 ? Colors.green : Colors.orange,
          ),
        ),
        if (difference.abs() >= 0.01)
          Text(
            difference > 0
                ? 'Remaining: \$${difference.toStringAsFixed(2)}'
                : 'Over by: \$${(-difference).toStringAsFixed(2)}',
            style: TextStyle(
              color: difference > 0 ? Colors.orange : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }

  Widget _buildPercentageValidation() {
    final totalPercent = _percentages.values.fold<int>(0, (sum, p) => sum + p);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Total: $totalPercent%',
          style: TextStyle(
            color: totalPercent == 100 ? Colors.green : Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (totalPercent != 100)
          Text(
            totalPercent < 100
                ? 'Remaining: ${100 - totalPercent}%'
                : 'Over by: ${totalPercent - 100}%',
            style: TextStyle(
              color: totalPercent < 100 ? Colors.orange : Colors.red,
            ),
          ),
      ],
    );
  }

  Widget _buildSplitSummary() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSplitStatusCard(),
          const SizedBox(height: 16),
          const Text(
            'Participants',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _billSplit!.participants.length,
            itemBuilder: (context, index) {
              final participant = _billSplit!.participants[index];
              return _ParticipantCard(
                participant: participant,
                onRemind: () => _remindParticipant(participant),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSplitStatusCard() {
    final paidCount = _billSplit!.participants
        .where((p) => p.status == ParticipantStatus.paid)
        .length;
    final totalCount = _billSplit!.participants.length;
    final paidAmount = _billSplit!.participants
        .where((p) => p.status == ParticipantStatus.paid)
        .fold<double>(0, (sum, p) => sum + p.amountOwed);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Split Status',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Chip(
                  label: Text(_billSplit!.status.name.toUpperCase()),
                  backgroundColor: _getSplitStatusColor(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: paidCount / totalCount,
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(height: 8),
            Text('$paidCount of $totalCount paid'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    Text(
                      '\$${_billSplit!.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Paid',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    Text(
                      '\$${paidAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getSplitStatusColor() {
    switch (_billSplit!.status) {
      case SplitStatus.active:
        return Colors.blue;
      case SplitStatus.completed:
        return Colors.green;
      case SplitStatus.cancelled:
        return Colors.red;
    }
  }

  bool _canCreateSplit() {
    switch (_splitMethod) {
      case SplitMethod.equal:
        return _equalSplits >= 2;
      case SplitMethod.custom:
        if (_customAmounts.isEmpty) return false;
        final total = _customAmounts.values.fold<double>(0, (s, a) => s + a);
        return (widget.totalAmount - total).abs() < 0.01;
      case SplitMethod.percentage:
        if (_percentages.isEmpty) return false;
        final total = _percentages.values.fold<int>(0, (s, p) => s + p);
        return total == 100;
      case SplitMethod.itemized:
        return false; // Handled in separate screen
    }
  }

  void _addCustomParticipant() {
    showDialog(
      context: context,
      builder: (context) {
        String name = '';
        return AlertDialog(
          title: const Text('Add Participant'),
          content: TextField(
            decoration: const InputDecoration(labelText: 'Name'),
            onChanged: (value) => name = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (name.isNotEmpty) {
                  setState(() => _customAmounts[name] = 0);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _addPercentageParticipant() {
    showDialog(
      context: context,
      builder: (context) {
        String name = '';
        return AlertDialog(
          title: const Text('Add Participant'),
          content: TextField(
            decoration: const InputDecoration(labelText: 'Name'),
            onChanged: (value) => name = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (name.isNotEmpty) {
                  setState(() => _percentages[name] = 0);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _sharePaymentLinks() async {
    try {
      await _billSplitService.sendPaymentLinks(_billSplit!.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment links sent to all participants')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send payment links: $e')),
        );
      }
    }
  }

  Future<void> _remindParticipant(BillParticipant participant) async {
    try {
      await _billSplitService.sendPaymentReminder(participant.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reminder sent to ${participant.userName}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send reminder')),
        );
      }
    }
  }
}

class _ParticipantCard extends StatelessWidget {
  final BillParticipant participant;
  final VoidCallback onRemind;

  const _ParticipantCard({
    required this.participant,
    required this.onRemind,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(),
          child: Icon(
            _getStatusIcon(),
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(participant.userName ?? 'Anonymous'),
        subtitle: Text(
          '\$${participant.amountOwed.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: participant.status == ParticipantStatus.pending
            ? TextButton(
                onPressed: onRemind,
                child: const Text('Remind'),
              )
            : Chip(
                label: Text(participant.status.name.toUpperCase()),
                backgroundColor: _getStatusColor(),
                labelStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (participant.status) {
      case ParticipantStatus.pending:
        return Colors.orange;
      case ParticipantStatus.paid:
        return Colors.green;
      case ParticipantStatus.declined:
        return Colors.red;
    }
  }

  IconData _getStatusIcon() {
    switch (participant.status) {
      case ParticipantStatus.pending:
        return Icons.schedule;
      case ParticipantStatus.paid:
        return Icons.check;
      case ParticipantStatus.declined:
        return Icons.close;
    }
  }
}
