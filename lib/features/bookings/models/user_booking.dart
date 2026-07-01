class UserBooking {
  final String id;
  final String eventName;
  final String venueName;
  final String? eventImage;
  final DateTime date;
  final String time;
  final String type; // 'Ticket' or 'Table'
  final String status; // confirmed, pending, cancelled
  final String? details;
  final bool hasQRCode;
  final String? qrCode;
  final String? confirmationCode;
  final double? totalAmount;
  final bool isUpcoming;
  final String sourceTable; // 'events_bookings' or 'clubs_bookings'

  UserBooking({
    required this.id,
    required this.eventName,
    required this.venueName,
    this.eventImage,
    required this.date,
    required this.time,
    required this.type,
    required this.status,
    this.details,
    required this.hasQRCode,
    this.qrCode,
    this.confirmationCode,
    this.totalAmount,
    required this.isUpcoming,
    required this.sourceTable,
  });

  factory UserBooking.fromEventBooking(Map<String, dynamic> json) {
    final event = json['events'] as Map<String, dynamic>? ?? {};
    final club = event['clubs'] as Map<String, dynamic>?;
    final images = event['images'] as List?;
    final dateStr = event['event_date'] as String?;
    final date = dateStr != null ? DateTime.tryParse(dateStr) ?? DateTime.now() : DateTime.now();
    final qty = json['ticket_quantity'] as int? ?? 1;
    final eventName = event['name'] as String?;

    return UserBooking(
      id: json['id'] as String,
      // If the event row was deleted after booking, show a graceful label
      eventName: eventName ?? 'Event (details unavailable)',
      venueName: club?['name'] as String? ?? 'Venue',
      eventImage: images != null && images.isNotEmpty ? images[0] as String? : null,
      date: date,
      time: event['start_time'] as String? ?? '20:00',
      type: 'Ticket',
      status: json['status'] as String? ?? 'pending',
      details: '$qty ${qty == 1 ? 'Ticket' : 'Tickets'}',
      hasQRCode: json['qr_code'] != null,
      qrCode: json['qr_code'] as String?,
      confirmationCode: json['confirmation_code'] as String?,
      totalAmount: (json['total_amount'] as num?)?.toDouble(),
      isUpcoming: date.isAfter(DateTime.now().subtract(const Duration(hours: 3))),
      sourceTable: 'events_bookings',
    );
  }

  factory UserBooking.fromClubBooking(Map<String, dynamic> json) {
    final club = json['clubs'] as Map<String, dynamic>? ?? {};
    final images = club['images'] as List?;
    final dateStr = json['booking_date'] as String?;
    final date = dateStr != null ? DateTime.tryParse(dateStr) ?? DateTime.now() : DateTime.now();
    final guestCount = json['guest_count'] as int? ?? 1;
    final visitTime = json['visit_time'] as String? ?? '20:00:00';
    final timeFormatted = visitTime.length >= 5 ? visitTime.substring(0, 5) : visitTime;

    return UserBooking(
      id: json['id'] as String,
      eventName: '${club['name'] ?? 'Club'} Reservation',
      venueName: club['name'] as String? ?? 'Venue',
      eventImage: images != null && images.isNotEmpty ? images[0] as String? : null,
      date: date,
      time: timeFormatted,
      type: 'Table',
      status: json['status'] as String? ?? 'pending',
      details: '$guestCount ${guestCount == 1 ? 'Guest' : 'Guests'}',
      hasQRCode: false,
      qrCode: null,
      confirmationCode: json['confirmation_code'] as String?,
      totalAmount: (json['total_amount'] as num?)?.toDouble(),
      isUpcoming: date.isAfter(DateTime.now().subtract(const Duration(hours: 3))),
      sourceTable: 'table_bookings',
    );
  }

  // Club table booking from `table_bookings` table (created via club detail flow)
  factory UserBooking.fromClubTableBooking(Map<String, dynamic> json) {
    final clubTable = json['club_tables'] as Map<String, dynamic>? ?? {};
    final club = clubTable['clubs'] as Map<String, dynamic>? ?? {};
    final images = club['images'] as List?;
    final dateStr = json['booking_date'] as String?;
    final date = dateStr != null ? DateTime.tryParse(dateStr) ?? DateTime.now() : DateTime.now();
    final guestCount = json['guest_count'] as int? ?? 1;
    final startTime = json['start_time'] as String? ?? '20:00:00';
    final timeFormatted = startTime.length >= 5 ? startTime.substring(0, 5) : startTime;
    final tableName = clubTable['name'] as String? ?? 'Table';
    final clubName = club['name'] as String? ?? 'Club';

    return UserBooking(
      id: json['id'] as String,
      eventName: '$clubName – $tableName',
      venueName: clubName,
      eventImage: images != null && images.isNotEmpty ? images[0] as String? : null,
      date: date,
      time: timeFormatted,
      type: 'Table',
      status: json['status'] as String? ?? 'pending',
      details: '$guestCount ${guestCount == 1 ? 'Guest' : 'Guests'}',
      hasQRCode: (json['ticket_code'] ?? json['qr_code']) != null,
      qrCode: json['ticket_code'] as String? ?? json['qr_code'] as String?,
      confirmationCode: json['confirmation_code'] as String? ??
          json['ticket_code'] as String?,
      totalAmount: (json['total_price'] as num?)?.toDouble(),
      isUpcoming: date.isAfter(DateTime.now().subtract(const Duration(hours: 3))),
      sourceTable: 'table_bookings',
    );
  }

  factory UserBooking.fromRSVP(Map<String, dynamic> json) {
    final event = json['events'] as Map<String, dynamic>? ?? {};
    final club = event['clubs'] as Map<String, dynamic>?;
    final images = event['images'] as List?;
    final dateStr = event['event_date'] as String?;
    final date = dateStr != null ? DateTime.tryParse(dateStr) ?? DateTime.now() : DateTime.now();
    final rsvpType = json['rsvp_type'] as String? ?? 'guestlist';

    return UserBooking(
      id: json['id'] as String,
      eventName: event['name'] as String? ?? 'Event (details unavailable)',
      venueName: club?['name'] as String? ?? 'Venue',
      eventImage: images != null && images.isNotEmpty ? images[0] as String? : null,
      date: date,
      time: event['start_time'] as String? ?? '20:00',
      type: rsvpType == 'table' ? 'Table' : 'Guestlist',
      status: json['status'] as String? ?? 'pending',
      details: rsvpType == 'table' ? 'Table Reservation' : 'Guestlist',
      hasQRCode: json['qr_code_data'] != null,
      qrCode: json['qr_code_data'] as String?,
      confirmationCode: json['verification_code'] as String?,
      totalAmount: null,
      isUpcoming: date.isAfter(DateTime.now().subtract(const Duration(hours: 3))),
      sourceTable: 'event_rsvps',
    );
  }

  factory UserBooking.fromTableBooking(Map<String, dynamic> json) {
    final event = json['events'] as Map<String, dynamic>? ?? {};
    final club = event['clubs'] as Map<String, dynamic>?;
    final images = event['images'] as List?;
    final dateStr = event['event_date'] as String?;
    final date = dateStr != null ? DateTime.tryParse(dateStr) ?? DateTime.now() : DateTime.now();
    final guestCount = json['guest_count'] as int? ?? 1;
    final status = json['status'] as String? ?? 'pending';
    // Normalize status: pending_payment → pending
    final displayStatus = status == 'pending_payment' ? 'pending' : status;

    return UserBooking(
      id: json['id'] as String,
      eventName: event['name'] as String? ?? 'Event (details unavailable)',
      venueName: club?['name'] as String? ?? 'Venue',
      eventImage: images != null && images.isNotEmpty ? images[0] as String? : null,
      date: date,
      time: event['start_time'] as String? ?? '20:00',
      type: 'Table',
      status: displayStatus,
      details: '$guestCount ${guestCount == 1 ? 'Guest' : 'Guests'}',
      hasQRCode: true,
      qrCode: json['id'] as String,
      confirmationCode: json['id'] as String?,
      totalAmount: (json['deposit_amount'] as num?)?.toDouble(),
      isUpcoming: date.isAfter(DateTime.now().subtract(const Duration(hours: 3))),
      sourceTable: 'event_table_bookings',
    );
  }

  String get formattedDate {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String get formattedTime {
    final parts = time.split(':');
    if (parts.length < 2) return time;
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = parts[1];
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '$displayHour:$minute $period';
  }

  String get shortId => id.length >= 8 ? id.substring(0, 8).toUpperCase() : id.toUpperCase();
}
