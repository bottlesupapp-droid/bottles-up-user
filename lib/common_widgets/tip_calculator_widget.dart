import 'package:flutter/material.dart';

class TipCalculatorWidget extends StatefulWidget {
  final double billAmount;
  final Function(double tipAmount, double totalAmount) onTipCalculated;

  const TipCalculatorWidget({
    super.key,
    required this.billAmount,
    required this.onTipCalculated,
  });

  @override
  State<TipCalculatorWidget> createState() => _TipCalculatorWidgetState();
}

class _TipCalculatorWidgetState extends State<TipCalculatorWidget> {
  double _selectedTipPercentage = 18.0;
  double _customTipAmount = 0.0;
  bool _isCustomTip = false;

  final List<double> _tipPresets = [10.0, 15.0, 18.0, 20.0, 25.0];

  @override
  void initState() {
    super.initState();
    _calculateTip();
  }

  void _calculateTip() {
    final tipAmount = _isCustomTip
        ? _customTipAmount
        : (widget.billAmount * _selectedTipPercentage / 100);
    final totalAmount = widget.billAmount + tipAmount;
    widget.onTipCalculated(tipAmount, totalAmount);
  }

  @override
  Widget build(BuildContext context) {
    final tipAmount = _isCustomTip
        ? _customTipAmount
        : (widget.billAmount * _selectedTipPercentage / 100);
    final totalAmount = widget.billAmount + tipAmount;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.calculate,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Text(
                'Add Tip',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Bill Amount
          _AmountRow(
            label: 'Bill Amount',
            amount: widget.billAmount,
          ),
          const SizedBox(height: 16),

          // Tip Presets
          if (!_isCustomTip) ...[
            const Text(
              'Select Tip Percentage',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _tipPresets.map((percentage) {
                final isSelected = _selectedTipPercentage == percentage;
                return ChoiceChip(
                  label: Text('${percentage.toInt()}%'),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedTipPercentage = percentage;
                      _calculateTip();
                    });
                  },
                );
              }).toList(),
            ),
          ],

          // Custom Tip Toggle
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () {
              setState(() {
                _isCustomTip = !_isCustomTip;
                if (!_isCustomTip) {
                  _customTipAmount = 0.0;
                }
                _calculateTip();
              });
            },
            icon: Icon(_isCustomTip ? Icons.grid_view : Icons.edit),
            label: Text(_isCustomTip ? 'Use Presets' : 'Custom Tip Amount'),
          ),

          // Custom Tip Input
          if (_isCustomTip) ...[
            const SizedBox(height: 12),
            TextField(
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Custom Tip Amount',
                prefixText: '\$',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _customTipAmount = 0.0;
                      _calculateTip();
                    });
                  },
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _customTipAmount = double.tryParse(value) ?? 0.0;
                  _calculateTip();
                });
              },
            ),
          ],

          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 16),

          // Tip Amount
          _AmountRow(
            label: 'Tip Amount',
            amount: tipAmount,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 12),

          // Total Amount
          _AmountRow(
            label: 'Total Amount',
            amount: totalAmount,
            isTotal: true,
            color: Theme.of(context).colorScheme.primary,
          ),

          // Tip Per Person (if split)
          if (widget.billAmount > 0) ...[
            const SizedBox(height: 16),
            _TipPerPersonRow(
              billAmount: widget.billAmount,
              tipAmount: tipAmount,
              totalAmount: totalAmount,
            ),
          ],
        ],
      ),
    );
  }
}

class _AmountRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool isTotal;
  final Color? color;

  const _AmountRow({
    required this.label,
    required this.amount,
    this.isTotal = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: color,
          ),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isTotal ? 20 : 18,
            fontWeight: FontWeight.bold,
            color: color ?? (isTotal ? Colors.green : null),
          ),
        ),
      ],
    );
  }
}

class _TipPerPersonRow extends StatefulWidget {
  final double billAmount;
  final double tipAmount;
  final double totalAmount;

  const _TipPerPersonRow({
    required this.billAmount,
    required this.tipAmount,
    required this.totalAmount,
  });

  @override
  State<_TipPerPersonRow> createState() => _TipPerPersonRowState();
}

class _TipPerPersonRowState extends State<_TipPerPersonRow> {
  int _peopleCount = 1;

  @override
  Widget build(BuildContext context) {
    final perPersonAmount = widget.totalAmount / _peopleCount;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Split Between',
                style: TextStyle(fontSize: 14),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: _peopleCount > 1
                        ? () => setState(() => _peopleCount--)
                        : null,
                    icon: const Icon(Icons.remove_circle_outline),
                    iconSize: 20,
                  ),
                  Text(
                    '$_peopleCount',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _peopleCount++),
                    icon: const Icon(Icons.add_circle_outline),
                    iconSize: 20,
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 8),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Per Person',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                '\$${perPersonAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
