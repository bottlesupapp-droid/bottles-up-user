import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class EventCalendarWidget extends StatefulWidget {
  final Function(DateTime selectedDate) onDateSelected;
  final Map<DateTime, List<Map<String, dynamic>>>? eventsByDate;

  const EventCalendarWidget({
    super.key,
    required this.onDateSelected,
    this.eventsByDate,
  });

  @override
  State<EventCalendarWidget> createState() => _EventCalendarWidgetState();
}

class _EventCalendarWidgetState extends State<EventCalendarWidget> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.now(),
          lastDay: DateTime.now().add(const Duration(days: 365)),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          calendarFormat: _calendarFormat,
          eventLoader: _getEventsForDay,
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
            widget.onDateSelected(selectedDay);
          },
          onFormatChanged: (format) {
            setState(() => _calendarFormat = format);
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            markerDecoration: const BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
            markersMaxCount: 3,
          ),
          headerStyle: const HeaderStyle(
            formatButtonVisible: true,
            titleCentered: true,
          ),
        ),
        if (_selectedDay != null && _getEventsForDay(_selectedDay!).isNotEmpty)
          _buildEventsList(_selectedDay!),
      ],
    );
  }

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    if (widget.eventsByDate == null) return [];

    // Find events for this date (ignoring time)
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return widget.eventsByDate!.entries
        .where((entry) {
          final entryDate = DateTime(
            entry.key.year,
            entry.key.month,
            entry.key.day,
          );
          return entryDate == normalizedDay;
        })
        .expand((entry) => entry.value)
        .toList();
  }

  Widget _buildEventsList(DateTime date) {
    final events = _getEventsForDay(date);

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              '${events.length} Events on ${_formatDate(date)}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: events.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final event = events[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: event['cover_image'] != null
                      ? NetworkImage(event['cover_image'] as String)
                      : null,
                  child: event['cover_image'] == null
                      ? const Icon(Icons.event, size: 20)
                      : null,
                ),
                title: Text(
                  event['name'] as String? ?? 'Event',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  event['venue_name'] as String? ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: event['min_price'] != null
                    ? Text(
                        'From \$${event['min_price']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
                onTap: () {
                  // Navigate to event details
                },
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

// Simple calendar without table_calendar package dependency
class SimpleEventCalendar extends StatefulWidget {
  final Function(DateTime selectedDate) onDateSelected;
  final Map<DateTime, int>? eventCounts;

  const SimpleEventCalendar({
    super.key,
    required this.onDateSelected,
    this.eventCounts,
  });

  @override
  State<SimpleEventCalendar> createState() => _SimpleEventCalendarState();
}

class _SimpleEventCalendarState extends State<SimpleEventCalendar> {
  DateTime _currentMonth = DateTime.now();
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildWeekDays(),
        _buildCalendarGrid(),
      ],
    );
  }

  Widget _buildHeader() {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              setState(() {
                _currentMonth = DateTime(
                  _currentMonth.year,
                  _currentMonth.month - 1,
                );
              });
            },
          ),
          Text(
            '${months[_currentMonth.month - 1]} ${_currentMonth.year}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              setState(() {
                _currentMonth = DateTime(
                  _currentMonth.year,
                  _currentMonth.month + 1,
                );
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWeekDays() {
    final weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return Row(
      children: weekDays.map((day) {
        return Expanded(
          child: Center(
            child: Text(
              day,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDayOfMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday % 7;
    final daysInMonth = lastDayOfMonth.day;

    final cells = <Widget>[];

    // Empty cells before first day
    for (int i = 0; i < firstWeekday; i++) {
      cells.add(const SizedBox());
    }

    // Days of month
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
      final isSelected = _selectedDate != null &&
          date.year == _selectedDate!.year &&
          date.month == _selectedDate!.month &&
          date.day == _selectedDate!.day;
      final isToday = date.year == DateTime.now().year &&
          date.month == DateTime.now().month &&
          date.day == DateTime.now().day;
      final isPast = date.isBefore(DateTime.now());
      final eventCount = widget.eventCounts?[date] ?? 0;

      cells.add(
        InkWell(
          onTap: isPast
              ? null
              : () {
                  setState(() => _selectedDate = date);
                  widget.onDateSelected(date);
                },
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : isToday
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                      : null,
              borderRadius: BorderRadius.circular(8),
              border: eventCount > 0 && !isSelected
                  ? Border.all(color: Colors.orange, width: 2)
                  : null,
            ),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    '$day',
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : isPast
                              ? Colors.grey[400]
                              : Colors.black,
                      fontWeight:
                          isToday || isSelected ? FontWeight.bold : null,
                    ),
                  ),
                ),
                if (eventCount > 0)
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$eventCount',
                        style: TextStyle(
                          color: isSelected ? Colors.orange : Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 7,
      children: cells,
    );
  }
}
