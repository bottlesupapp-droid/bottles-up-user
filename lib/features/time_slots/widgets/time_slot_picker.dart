import 'package:flutter/material.dart';
import '../models/time_slot.dart';
import '../services/time_slot_service.dart';

class TimeSlotPicker extends StatefulWidget {
  final String venueId;
  final DateTime initialDate;
  final Function(TimeSlot) onSlotSelected;
  final String? tableId;

  const TimeSlotPicker({
    super.key,
    required this.venueId,
    required this.initialDate,
    required this.onSlotSelected,
    this.tableId,
  });

  @override
  State<TimeSlotPicker> createState() => _TimeSlotPickerState();
}

class _TimeSlotPickerState extends State<TimeSlotPicker> {
  final _timeSlotService = TimeSlotService();

  DateTime _selectedDate;
  List<TimeSlot> _availableSlots = [];
  TimeSlot? _selectedSlot;
  bool _isLoading = true;

  _TimeSlotPickerState() : _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _loadSlots();
  }

  Future<void> _loadSlots() async {
    setState(() => _isLoading = true);
    try {
      final slots = await _timeSlotService.getAvailableSlots(
        venueId: widget.venueId,
        date: _selectedDate,
        tableId: widget.tableId,
      );
      setState(() {
        _availableSlots = slots;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading slots: $e')),
        );
      }
    }
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
      _selectedSlot = null;
    });
    _loadSlots();
  }

  void _selectSlot(TimeSlot slot) {
    setState(() => _selectedSlot = slot);
    widget.onSlotSelected(slot);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date selector
        _buildDateSelector(),

        const SizedBox(height: 16),

        // Time slots grid
        if (_isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            ),
          )
        else if (_availableSlots.isEmpty)
          _buildEmptyState()
        else
          _buildSlotsGrid(),
      ],
    );
  }

  Widget _buildDateSelector() {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 14, // Next 2 weeks
        itemBuilder: (context, index) {
          final date = DateTime.now().add(Duration(days: index));
          final isSelected = date.day == _selectedDate.day &&
              date.month == _selectedDate.month &&
              date.year == _selectedDate.year;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _DateCard(
              date: date,
              isSelected: isSelected,
              onTap: () => _selectDate(date),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSlotsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 2.5,
      ),
      itemCount: _availableSlots.length,
      itemBuilder: (context, index) {
        final slot = _availableSlots[index];
        final isSelected = _selectedSlot?.id == slot.id;

        return _TimeSlotCard(
          slot: slot,
          isSelected: isSelected,
          onTap: () => _selectSlot(slot),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              'No available time slots',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try selecting a different date',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateCard extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final VoidCallback onTap;

  const _DateCard({
    required this.date,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    return SizedBox(
      width: 60,
      child: Card(
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  dayNames[date.weekday - 1],
                  style: TextStyle(
                    fontSize: 10,
                    color: isSelected ? Colors.white : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${date.day}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  monthNames[date.month - 1],
                  style: TextStyle(
                    fontSize: 10,
                    color: isSelected ? Colors.white : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TimeSlotCard extends StatelessWidget {
  final TimeSlot slot;
  final bool isSelected;
  final VoidCallback onTap;

  const _TimeSlotCard({
    required this.slot,
    required this.isSelected,
    required this.onTap,
  });

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:${time.minute.toString().padLeft(2, '0')} $period';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _formatTime(slot.startTime),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.black,
                ),
              ),
              if (slot.price != null) ...[
                const SizedBox(height: 2),
                Text(
                  '\$${slot.price!.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// Bottom sheet version
class TimeSlotPickerSheet extends StatelessWidget {
  final String venueId;
  final DateTime initialDate;
  final Function(TimeSlot) onSlotSelected;
  final String? tableId;

  const TimeSlotPickerSheet({
    super.key,
    required this.venueId,
    required this.initialDate,
    required this.onSlotSelected,
    this.tableId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Select Time Slot',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: TimeSlotPicker(
              venueId: venueId,
              initialDate: initialDate,
              tableId: tableId,
              onSlotSelected: (slot) {
                onSlotSelected(slot);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
