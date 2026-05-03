import 'package:freezed_annotation/freezed_annotation.dart';

part 'waitlist.freezed.dart';
part 'waitlist.g.dart';

enum WaitlistStatus {
  @JsonValue('active')
  active,
  @JsonValue('converted')
  converted,
  @JsonValue('expired')
  expired,
  @JsonValue('cancelled')
  cancelled,
}

@freezed
class WaitlistEntry with _$WaitlistEntry {
  const WaitlistEntry._();

  const factory WaitlistEntry({
    required String id,
    required String userId,
    required String eventId,
    required int position,
    required int partySize,
    String? userName,
    String? userEmail,
    String? userPhone,
    String? eventName,
    DateTime? eventDate,
    @Default(WaitlistStatus.active) WaitlistStatus status,
    String? notes,
    DateTime? notifiedAt,
    DateTime? expiresAt,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _WaitlistEntry;

  factory WaitlistEntry.fromJson(Map<String, dynamic> json) =>
      _$WaitlistEntryFromJson(json);

  factory WaitlistEntry.fromSupabase(Map<String, dynamic> data) {
    return WaitlistEntry(
      id: data['id'] as String,
      userId: data['user_id'] as String,
      eventId: data['event_id'] as String,
      position: data['position'] as int,
      partySize: data['party_size'] as int? ?? 1,
      userName: data['user_name'] as String?,
      userEmail: data['user_email'] as String?,
      userPhone: data['user_phone'] as String?,
      eventName: data['event_name'] as String?,
      eventDate: data['event_date'] != null
          ? DateTime.parse(data['event_date'] as String)
          : null,
      status: WaitlistStatus.values.firstWhere(
        (s) => s.name == data['status'],
        orElse: () => WaitlistStatus.active,
      ),
      notes: data['notes'] as String?,
      notifiedAt: data['notified_at'] != null
          ? DateTime.parse(data['notified_at'] as String)
          : null,
      expiresAt: data['expires_at'] != null
          ? DateTime.parse(data['expires_at'] as String)
          : null,
      createdAt: DateTime.parse(data['created_at'] as String),
      updatedAt: data['updated_at'] != null
          ? DateTime.parse(data['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toSupabase() {
    return {
      'user_id': userId,
      'event_id': eventId,
      'party_size': partySize,
      'notes': notes,
    };
  }
}

@freezed
class WaitlistStats with _$WaitlistStats {
  const factory WaitlistStats({
    required String eventId,
    required int totalWaiting,
    required int averageWaitTime,
    required int conversionRate,
    required DateTime lastUpdated,
  }) = _WaitlistStats;

  factory WaitlistStats.fromJson(Map<String, dynamic> json) =>
      _$WaitlistStatsFromJson(json);
}
