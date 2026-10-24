import 'package:freezed_annotation/freezed_annotation.dart';

part 'club_hours.freezed.dart';
part 'club_hours.g.dart';

@freezed
class ClubHours with _$ClubHours {
  const factory ClubHours({
    required String id,
    required String clubId,
    required int dayOfWeek, // 0 = Sunday, 1 = Monday, ..., 6 = Saturday
    String? openTime,
    String? closeTime,
    @Default(false) bool isClosed,
    DateTime? createdAt,
  }) = _ClubHours;

  factory ClubHours.fromJson(Map<String, dynamic> json) => _$ClubHoursFromJson(json);

  factory ClubHours.fromSupabase(Map<String, dynamic> data) {
    return ClubHours(
      id: data['id']?.toString() ?? '',
      clubId: data['club_id']?.toString() ?? '',
      dayOfWeek: int.tryParse(data['day_of_week']?.toString() ?? '0') ?? 0,
      openTime: data['open_time']?.toString(),
      closeTime: data['close_time']?.toString(),
      isClosed: data['is_closed'] ?? false,
      createdAt: data['created_at'] != null
          ? DateTime.tryParse(data['created_at'].toString())
          : null,
    );
  }
}

extension ClubHoursX on ClubHours {
  /// Get day name
  String get dayName {
    switch (dayOfWeek) {
      case 0:
        return 'Sunday';
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      default:
        return 'Unknown';
    }
  }

  /// Get short day name
  String get shortDayName {
    switch (dayOfWeek) {
      case 0:
        return 'Sun';
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      default:
        return 'Unknown';
    }
  }

  /// Format hours for display
  String get formattedHours {
    if (isClosed) return 'Closed';
    if (openTime == null || closeTime == null) return 'Hours not set';
    return '$openTime - $closeTime';
  }

  /// Check if club is open at a specific time on this day
  bool isOpenAtTime(String time) {
    if (isClosed || openTime == null || closeTime == null) return false;

    // Parse times (assuming format HH:mm:ss)
    final openHour = int.tryParse(openTime!.split(':')[0]) ?? 0;
    final openMinute = int.tryParse(openTime!.split(':')[1]) ?? 0;
    final closeHour = int.tryParse(closeTime!.split(':')[0]) ?? 0;
    final closeMinute = int.tryParse(closeTime!.split(':')[1]) ?? 0;

    final checkHour = int.tryParse(time.split(':')[0]) ?? 0;
    final checkMinute = int.tryParse(time.split(':')[1]) ?? 0;

    final openTotalMinutes = openHour * 60 + openMinute;
    final closeTotalMinutes = closeHour * 60 + closeMinute;
    final checkTotalMinutes = checkHour * 60 + checkMinute;

    // Handle overnight hours (e.g., 21:00 - 04:00)
    if (closeTotalMinutes < openTotalMinutes) {
      return checkTotalMinutes >= openTotalMinutes || checkTotalMinutes <= closeTotalMinutes;
    }

    return checkTotalMinutes >= openTotalMinutes && checkTotalMinutes <= closeTotalMinutes;
  }
}