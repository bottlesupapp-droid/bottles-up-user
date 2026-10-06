import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../providers/venue_provider.dart';

class VenueInquiryScreen extends ConsumerStatefulWidget {
  final String venueId;
  final String venueName;

  const VenueInquiryScreen({
    super.key,
    required this.venueId,
    required this.venueName,
  });

  @override
  ConsumerState<VenueInquiryScreen> createState() => _VenueInquiryScreenState();
}

class _VenueInquiryScreenState extends ConsumerState<VenueInquiryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _eventNameController = TextEditingController();
  final _messageController = TextEditingController();
  final _guestsController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay _startTime = const TimeOfDay(hour: 18, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 23, minute: 0);

  bool _isSubmitting = false;

  @override
  void dispose() {
    _eventNameController.dispose();
    _messageController.dispose();
    _guestsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Inquiry'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Venue Info
            Card(
              child: ListTile(
                leading: const Icon(Icons.place),
                title: Text(widget.venueName),
                subtitle: const Text('Venue'),
              ),
            ),
            const Gap(24),

            // Event Name
            TextFormField(
              controller: _eventNameController,
              decoration: const InputDecoration(
                labelText: 'Event Name',
                hintText: 'e.g., Birthday Party',
                prefixIcon: Icon(Icons.event),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter event name';
                }
                return null;
              },
            ),
            const Gap(16),

            // Event Date
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Event Date',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  _selectedDate != null
                      ? DateFormat('MMMM d, yyyy').format(_selectedDate!)
                      : 'Select date',
                  style: TextStyle(
                    color: _selectedDate != null ? null : Colors.grey,
                  ),
                ),
              ),
            ),
            const Gap(16),

            // Time Range
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectTime(context, isStartTime: true),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Start Time',
                        prefixIcon: Icon(Icons.access_time),
                      ),
                      child: Text(_startTime.format(context)),
                    ),
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectTime(context, isStartTime: false),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'End Time',
                        prefixIcon: Icon(Icons.access_time),
                      ),
                      child: Text(_endTime.format(context)),
                    ),
                  ),
                ),
              ],
            ),
            const Gap(16),

            // Expected Guests
            TextFormField(
              controller: _guestsController,
              decoration: const InputDecoration(
                labelText: 'Expected Guests',
                hintText: 'e.g., 100',
                prefixIcon: Icon(Icons.people),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter number of guests';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const Gap(16),

            // Message
            TextFormField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Message',
                hintText: 'Tell us about your event...',
                prefixIcon: Icon(Icons.message),
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a message';
                }
                return null;
              },
            ),
            const Gap(32),

            // Submit Button
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitInquiry,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Send Inquiry'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime(BuildContext context, {required bool isStartTime}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Future<void> _submitInquiry() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select event date')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await ref.read(venueInquiriesProvider.notifier).submitInquiry(
            venueId: widget.venueId,
            eventName: _eventNameController.text,
            eventDate: _selectedDate!,
            startTime: '${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}:00',
            endTime: '${_endTime.hour.toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}:00',
            expectedGuests: int.parse(_guestsController.text),
            message: _messageController.text,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Inquiry sent successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}
