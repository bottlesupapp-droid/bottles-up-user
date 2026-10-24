import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../home/models/club.dart';
import '../../../shared/widgets/widgets.dart';
import '../providers/table_booking_providers.dart';

class TableBookingScreen extends ConsumerStatefulWidget {
  final Club club;

  const TableBookingScreen({
    super.key,
    required this.club,
  });

  @override
  ConsumerState<TableBookingScreen> createState() => _TableBookingScreenState();
}

class _TableBookingScreenState extends ConsumerState<TableBookingScreen> {
  bool _isLoading = false;
  String? _errorMessage;
  int? _maxGuestsPerBooking;
  int _guestCount = 4;
  DateTime _selectedDate = DateTime.now();
  String? _selectedTime;
  late String _clubId;

  @override
  void initState() {
    super.initState();
    _clubId = widget.club.id;
    _loadClubDetails();
  }

  void _loadClubDetails() async {
    try {
      final clubDetails = await ref.read(clubBookingDetailsProvider(_clubId).future);
      if (clubDetails != null && mounted) {
        setState(() {
          _maxGuestsPerBooking = clubDetails.maxGuestsPerBooking ?? 20;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load club details';
        });
      }
    }
  }

  // Generate dates for the next 7 days
  List<DateTime> get _availableDates {
    final List<DateTime> dates = [];
    for (int i = 0; i < 7; i++) {
      dates.add(DateTime.now().add(Duration(days: i)));
    }
    return dates;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Book a Table',
      ),
      bottomNavigationBar: _buildBottomButton(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Guests Section
                  _buildGuestsSection(),
                  
                  const Gap(32),
                  
                  // Date Section
                  _buildDateSection(),
                  
                  const Gap(32),
                  
                  // Time Section
                  _buildTimeSection(),

                  const Gap(32),

                  // Error message
                  if (_errorMessage != null) _buildErrorMessage(),

                  const Gap(100), // Space for bottom button
                  
                
                ],
              ),
            ),
          ),
          
          // Bottom Continue Button
          
        ],
      ),
    );
  }

  Widget _buildGuestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Guests',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        
        const Gap(20),
        
        // Guest Counter
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Decrease Button
            GestureDetector(
              onTap: () {
                if (_guestCount > 1) {
                  HapticFeedback.lightImpact();
                  setState(() {
                    _guestCount--;
                    _selectedTime = null; // Reset time when guest count changes
                  });
                  _refreshTimeSlots();
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.15,
                height: MediaQuery.of(context).size.width * 0.15,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.remove,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
            
            const Gap(16),
            
            // Guest Count Display
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.width * 0.15,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Text(
                    _guestCount.toString(),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
            
            const Gap(16),
            
            // Increase Button
            GestureDetector(
              onTap: () {
                final maxGuests = _maxGuestsPerBooking ?? 20;
                if (_guestCount < maxGuests) {
                  HapticFeedback.lightImpact();
                  setState(() {
                    _guestCount++;
                    _selectedTime = null; // Reset time when guest count changes
                  });
                  _refreshTimeSlots();
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.15,
                height: MediaQuery.of(context).size.width * 0.15,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Date',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        
        const Gap(16),
        
        // Date Pills
        SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _availableDates.length,
            itemBuilder: (context, index) {
              final date = _availableDates[index];
              final isSelected = _isSameDay(date, _selectedDate);
              final isToday = _isSameDay(date, DateTime.now());
              
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = date;
                      _selectedTime = null; // Reset time when date changes
                    });
                    _refreshTimeSlots();
                  },
                  child: Container(
                    width: 104,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isToday ? 'Today' : _getWeekdayName(date),
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected
                                ? Colors.white
                                : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Gap(4),
                        Text(
                          '${date.day} ${_getMonthName(date)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: isSelected
                                ? Colors.white
                                : Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Time',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),

        const Gap(16),

        // Time Slots from Provider
        Consumer(
          builder: (context, ref, child) {
            final timeSlotsAsync = ref.watch(availableTimeSlotsProvider(
              clubId: _clubId,
              date: _selectedDate,
              guestCount: _guestCount,
            ));

            return timeSlotsAsync.when(
              data: (timeSlots) {
                if (timeSlots.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.schedule_outlined,
                          size: 48,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                        ),
                        const Gap(12),
                        Text(
                          'No available time slots',
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Gap(8),
                        Text(
                          'Try selecting a different date or reducing guest count',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: timeSlots.length,
                  itemBuilder: (context, index) {
                    final time = timeSlots[index];
                    final isSelected = time == _selectedTime;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTime = time;
                          _errorMessage = null;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            time,
                            style: TextStyle(
                              fontSize: 14,
                              color: isSelected
                                  ? Colors.white
                                  : Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, stack) => Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Error loading time slots: $error',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBottomButton() {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(
            top: BorderSide(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
              width: 1,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: FilledButton(
          onPressed: _selectedTime != null && !_isLoading ? _handleContinue : null,
          style: FilledButton.styleFrom(
            fixedSize: const Size(double.infinity, 56),
            backgroundColor: Theme.of(context).colorScheme.primary,
            disabledBackgroundColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }

  void _handleContinue() async {
    if (_selectedTime == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Validate booking first
      final isValid = await ref.read(bookingValidatorProvider(
        clubId: _clubId,
        date: _selectedDate,
        timeSlot: _selectedTime!,
        guestCount: _guestCount,
      ).future);

      if (!isValid) {
        setState(() {
          _errorMessage = 'This time slot is no longer available';
          _selectedTime = null;
        });
        _refreshTimeSlots();
        return;
      }

      // Navigate to table selection with booking details
      if (mounted) {
        final dateStr = _selectedDate.toIso8601String().split('T')[0];
        final clubName = Uri.encodeComponent(widget.club.name);
        context.push(
          '/table-selection/${widget.club.id}?date=$dateStr&timeSlot=$_selectedTime&guestCount=$_guestCount&clubName=$clubName'
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to validate booking: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _refreshTimeSlots() {
    ref.invalidate(availableTimeSlotsProvider(
      clubId: _clubId,
      date: _selectedDate,
      guestCount: _guestCount,
    ));
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.error.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Theme.of(context).colorScheme.onErrorContainer,
            size: 20,
          ),
          const Gap(12),
          Expanded(
            child: Text(
              _errorMessage!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onErrorContainer,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  String _getWeekdayName(DateTime date) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[date.weekday - 1];
  }

  String _getMonthName(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                   'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[date.month - 1];
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_getMonthName(date)} ${date.year}';
  }
} 