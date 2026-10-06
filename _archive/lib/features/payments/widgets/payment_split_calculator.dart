import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaymentSplitCalculator extends StatefulWidget {
  final double totalAmount;
  final Function(Map<String, double>)? onSplitCalculated;

  const PaymentSplitCalculator({
    super.key,
    required this.totalAmount,
    this.onSplitCalculated,
  });

  @override
  State<PaymentSplitCalculator> createState() => _PaymentSplitCalculatorState();
}

class _PaymentSplitCalculatorState extends State<PaymentSplitCalculator> {
  int _numberOfPeople = 2;
  double _tipPercentage = 18.0;
  double _taxPercentage = 0.0;
  bool _includeTip = true;
  bool _includeTax = false;
  final Map<int, double> _customAmounts = {};

  double get _subtotal => widget.totalAmount;
  double get _taxAmount => _includeTax ? _subtotal * (_taxPercentage / 100) : 0;
  double get _tipAmount => _includeTip ? (_subtotal + _taxAmount) * (_tipPercentage / 100) : 0;
  double get _grandTotal => _subtotal + _taxAmount + _tipAmount;
  double get _perPersonAmount => _grandTotal / _numberOfPeople;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.calculate, color: Colors.blue),
                const SizedBox(width: 12),
                const Text(
                  'Split Payment Calculator',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Subtotal
            _buildAmountRow('Subtotal', _subtotal, isHighlighted: false),
            const Divider(height: 24),

            // Tax
            _buildSwitchRow(
              'Include Tax',
              _includeTax,
              (value) => setState(() => _includeTax = value),
            ),
            if (_includeTax) ...[
              const SizedBox(height: 12),
              _buildPercentageSlider(
                'Tax',
                _taxPercentage,
                (value) => setState(() => _taxPercentage = value),
                max: 20,
              ),
              _buildAmountRow('Tax Amount', _taxAmount),
            ],
            const Divider(height: 24),

            // Tip
            _buildSwitchRow(
              'Include Tip',
              _includeTip,
              (value) => setState(() => _includeTip = value),
            ),
            if (_includeTip) ...[
              const SizedBox(height: 12),
              _buildTipPresets(),
              const SizedBox(height: 8),
              _buildPercentageSlider(
                'Tip',
                _tipPercentage,
                (value) => setState(() => _tipPercentage = value),
                max: 30,
              ),
              _buildAmountRow('Tip Amount', _tipAmount),
            ],
            const Divider(height: 24),

            // Grand Total
            _buildAmountRow(
              'Grand Total',
              _grandTotal,
              isHighlighted: true,
              fontSize: 20,
            ),
            const SizedBox(height: 20),

            // Number of People
            _buildPeopleSelector(),
            const SizedBox(height: 20),

            // Per Person Amount
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Per Person',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${_perPersonAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.person,
                    size: 48,
                    color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.3),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Breakdown by person
            _buildPersonBreakdown(),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountRow(
    String label,
    double amount, {
    bool isHighlighted = false,
    double fontSize = 16,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
              color: isHighlighted ? Theme.of(context).colorScheme.primary : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchRow(String label, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildPercentageSlider(
    String label,
    double value,
    Function(double) onChanged, {
    double max = 25,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$label (${value.toStringAsFixed(1)}%)',
              style: const TextStyle(fontSize: 14),
            ),
            SizedBox(
              width: 80,
              child: TextField(
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  suffixText: '%',
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                ),
                controller: TextEditingController(text: value.toStringAsFixed(1)),
                onChanged: (text) {
                  final newValue = double.tryParse(text);
                  if (newValue != null && newValue >= 0 && newValue <= max) {
                    onChanged(newValue);
                  }
                },
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: 0,
          max: max,
          divisions: (max * 10).toInt(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildTipPresets() {
    final presets = [
      {'label': '15%', 'value': 15.0},
      {'label': '18%', 'value': 18.0},
      {'label': '20%', 'value': 20.0},
      {'label': '25%', 'value': 25.0},
    ];

    return Wrap(
      spacing: 8,
      children: presets.map((preset) {
        final isSelected = _tipPercentage == preset['value'];
        return ChoiceChip(
          label: Text(preset['label'] as String),
          selected: isSelected,
          onSelected: (selected) {
            setState(() => _tipPercentage = preset['value'] as double);
          },
        );
      }).toList(),
    );
  }

  Widget _buildPeopleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Number of People',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton.filled(
              icon: const Icon(Icons.remove),
              onPressed: _numberOfPeople > 1
                  ? () => setState(() => _numberOfPeople--)
                  : null,
            ),
            const SizedBox(width: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$_numberOfPeople',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 24),
            IconButton.filled(
              icon: const Icon(Icons.add),
              onPressed: _numberOfPeople < 20
                  ? () => setState(() => _numberOfPeople++)
                  : null,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPersonBreakdown() {
    return ExpansionTile(
      title: const Text('Breakdown by Person'),
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _numberOfPeople,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                child: Text('${index + 1}'),
              ),
              title: Text('Person ${index + 1}'),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${_perPersonAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Each',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          },
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Breakdown:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildBreakdownItem(
                'Subtotal',
                _subtotal / _numberOfPeople,
              ),
              if (_includeTax)
                _buildBreakdownItem(
                  'Tax',
                  _taxAmount / _numberOfPeople,
                ),
              if (_includeTip)
                _buildBreakdownItem(
                  'Tip',
                  _tipAmount / _numberOfPeople,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBreakdownItem(String label, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13)),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}

// Compact version for quick calculations
class CompactSplitCalculator extends StatefulWidget {
  final double amount;
  final Function(int people, double perPerson)? onCalculated;

  const CompactSplitCalculator({
    super.key,
    required this.amount,
    this.onCalculated,
  });

  @override
  State<CompactSplitCalculator> createState() => _CompactSplitCalculatorState();
}

class _CompactSplitCalculatorState extends State<CompactSplitCalculator> {
  int _people = 2;

  double get _perPerson => widget.amount / _people;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Split',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, size: 20),
                    onPressed: _people > 1
                        ? () => setState(() => _people--)
                        : null,
                  ),
                  Text(
                    '$_people',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, size: 20),
                    onPressed: _people < 10
                        ? () => setState(() => _people++)
                        : null,
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Per person:'),
              Text(
                '\$${_perPerson.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
