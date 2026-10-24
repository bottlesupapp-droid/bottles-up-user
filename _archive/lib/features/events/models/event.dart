import 'package:freezed_annotation/freezed_annotation.dart';

part 'event.freezed.dart';
part 'event.g.dart';

@freezed
class Event with _$Event {
  const factory Event({
    required String id,
    required String userId,
    required String categoryId,
    required String clubId,
    required String zoneId,
    required String name,
    required String description,
    required DateTime eventDate,
    required String startTime,
    required String endTime,
    required double ticketPrice,
    required int maxCapacity,
    int? currentBookings,
    int? rsvpCount,
    int? tableBookingCount,
    String? dressCode,
    String? invitationCode,
    @Default(false) bool isPrivate,
    @Default(true) bool locationHidden,
    List<String>? images,
    String? tableArrangementImageUrl,
    @Default('upcoming') String status,
    @Default(true) bool isActive,
    @Default(false) bool isFeatured,
    DateTime? createdAt,
    DateTime? updatedAt,

    // Related data from joins
    String? categoryName,
    String? clubName,
    String? clubLocation,
    String? clubImageUrl,
    String? zoneName,
    String? zoneDescription,
  }) = _Event;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  /// Factory method to create Event from Supabase response
  factory Event.fromSupabase(Map<String, dynamic> data) {
    return Event(
      id: data['id'] as String,
      userId: data['user_id'] as String,
      categoryId: data['category_id'] as String? ?? '',
      clubId: data['club_id'] as String? ?? '',
      zoneId: data['zone_id'] as String? ?? '',
      name: data['name'] as String,
      description: data['description'] as String? ?? '',
      eventDate: DateTime.parse(data['event_date'] as String),
      startTime: (data['start_time'] as String?) ?? '00:00:00',
      endTime: (data['end_time'] as String?) ?? '23:59:59',
      ticketPrice: _parsePrice(data['ticket_price']),
      maxCapacity: data['max_capacity'] as int? ?? 0,
      currentBookings: data['current_bookings'] as int? ?? 0,
      rsvpCount: data['rsvp_count'] as int? ?? 0,
      tableBookingCount: data['table_booking_count'] as int? ?? 0,
      dressCode: data['dress_code'] as String?,
      invitationCode: data['invitation_code'] as String?,
      isPrivate: data['is_private'] as bool? ?? false,
      locationHidden: data['location_hidden'] as bool? ?? true,
      images: data['images'] != null ? List<String>.from(data['images']) : null,
      tableArrangementImageUrl: data['table_arrangement_image_url'] as String?,
      status: data['status'] as String? ?? 'upcoming',
      isActive: data['is_active'] as bool? ?? true,
      isFeatured: data['is_featured'] as bool? ?? false,
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at'] as String)
          : null,
      updatedAt: data['updated_at'] != null
          ? DateTime.parse(data['updated_at'] as String)
          : null,

      // Related data from joins
      categoryName: data['category_name'] as String?,
      clubName: data['club_name'] as String?,
      clubLocation: data['club_location'] as String?,
      clubImageUrl: data['club_image_url'] as String?,
      zoneName: data['zone_name'] as String?,
      zoneDescription: data['zone_description'] as String?,
    );
  }

  /// Helper method to parse price from various formats
  static double _parsePrice(dynamic price) {
    if (price == null) return 0.0;
    if (price is num) return price.toDouble();
    if (price is String) {
      final parsed = double.tryParse(price);
      return parsed ?? 0.0;
    }
    return 0.0;
  }
}

extension EventX on Event {
  /// Format ticket price for display
  String get formattedPrice => ticketPrice > 0 ? '\$${ticketPrice.toStringAsFixed(0)}' : 'Free';

  /// Get availability status
  bool get isAvailable {
    return currentBookings! < maxCapacity;
  }

  /// Get availability percentage
  double get availabilityPercentage {
    if (maxCapacity == 0) return 1.0;
    return (maxCapacity - currentBookings!) / maxCapacity;
  }

  /// Get formatted date
  String get formattedDate {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[eventDate.month - 1]} ${eventDate.day}, ${eventDate.year}';
  }

  /// Get formatted time range
  String get formattedTime {
    return '${_formatTimeToAmPm(startTime)} - ${_formatTimeToAmPm(endTime)}';
  }

  /// Convert 24-hour time to 12-hour AM/PM format
  String _formatTimeToAmPm(String timeString) {
    try {
      // Handle different time formats
      if (timeString.contains(':')) {
        final parts = timeString.split(':');
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);

        final period = hour >= 12 ? 'PM' : 'AM';
        final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
        final displayMinute = minute.toString().padLeft(2, '0');

        return '$displayHour:$displayMinute $period';
      }
      return timeString;
    } catch (e) {
      return timeString; // Return original if parsing fails
    }
  }

  /// Check if event is happening today
  bool get isToday {
    final now = DateTime.now();
    return eventDate.year == now.year &&
           eventDate.month == now.month &&
           eventDate.day == now.day;
  }

  /// Check if event is upcoming (in the future)
  bool get isUpcoming => eventDate.isAfter(DateTime.now());

  /// Get primary image URL
  String get primaryImageUrl {
    if (images != null && images!.isNotEmpty) {
      return images!.first;
    }
    return clubImageUrl ?? 'https://images.unsplash.com/photo-1571266028243-d220a9937dad?w=400&h=300&fit=crop';
  }

  /// Get total attendees (RSVP + Table bookings)
  int get totalAttendees => (rsvpCount ?? 0) + (tableBookingCount ?? 0);

  /// Get venue display name
  String get venueDisplay => locationHidden ? 'Location TBA' : (clubName ?? 'Venue TBA');
} 