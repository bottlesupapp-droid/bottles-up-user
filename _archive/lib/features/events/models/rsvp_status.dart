import 'package:freezed_annotation/freezed_annotation.dart';

part 'rsvp_status.freezed.dart';
part 'rsvp_status.g.dart';

/// Three-state RSVP status
enum RsvpResponse {
  @JsonValue('going')
  going,
  @JsonValue('maybe')
  maybe,
  @JsonValue('not_going')
  notGoing,
  @JsonValue('not_responded')
  notResponded,
}

@freezed
class EnhancedEventRSVP with _$EnhancedEventRSVP {
  const factory EnhancedEventRSVP({
    required String id,
    required String eventId,
    required String userId,
    required String userName,
    String? userAvatar,
    required String email,
    String? phone,
    required RsvpResponse response,
    @Default(false) bool plusOneEnabled,
    String? plusOneName,
    String? specialRequests,
    String? verificationCode,
    String? qrCodeData,
    @Default(false) bool isAttended,
    @Default(false) bool isVisible,
    DateTime? respondedAt,
    DateTime? verifiedAt,
    String? verifiedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _EnhancedEventRSVP;

  factory EnhancedEventRSVP.fromJson(Map<String, dynamic> json) =>
      _$EnhancedEventRSVPFromJson(json);

  factory EnhancedEventRSVP.fromSupabase(Map<String, dynamic> data) {
    return EnhancedEventRSVP(
      id: data['id'] as String,
      eventId: data['event_id'] as String,
      userId: data['user_id'] as String,
      userName: data['user_name'] as String? ?? 'Unknown',
      userAvatar: data['user_avatar'] as String?,
      email: data['email'] as String,
      phone: data['phone'] as String?,
      response: RsvpResponse.values.firstWhere(
        (r) => r.name == data['response'],
        orElse: () => RsvpResponse.notResponded,
      ),
      plusOneEnabled: data['plus_one_enabled'] as bool? ?? false,
      plusOneName: data['plus_one_name'] as String?,
      specialRequests: data['special_requests'] as String?,
      verificationCode: data['verification_code'] as String?,
      qrCodeData: data['qr_code_data'] as String?,
      isAttended: data['is_attended'] as bool? ?? false,
      isVisible: data['is_visible'] as bool? ?? false,
      respondedAt: data['responded_at'] != null
          ? DateTime.parse(data['responded_at'] as String)
          : null,
      verifiedAt: data['verified_at'] != null
          ? DateTime.parse(data['verified_at'] as String)
          : null,
      verifiedBy: data['verified_by'] as String?,
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at'] as String)
          : null,
      updatedAt: data['updated_at'] != null
          ? DateTime.parse(data['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toSupabase() {
    return {
      'event_id': eventId,
      'user_id': userId,
      'user_name': userName,
      'user_avatar': userAvatar,
      'email': email,
      'phone': phone,
      'response': response.name,
      'plus_one_enabled': plusOneEnabled,
      'plus_one_name': plusOneName,
      'special_requests': specialRequests,
      'is_visible': isVisible,
      'responded_at': respondedAt?.toIso8601String(),
    };
  }
}

@freezed
class RsvpCounts with _$RsvpCounts {
  const factory RsvpCounts({
    @Default(0) int going,
    @Default(0) int maybe,
    @Default(0) int notGoing,
    @Default(0) int notResponded,
    @Default(0) int total,
    @Default(0) int plusOnes,
  }) = _RsvpCounts;

  factory RsvpCounts.fromJson(Map<String, dynamic> json) =>
      _$RsvpCountsFromJson(json);

  factory RsvpCounts.fromSupabase(Map<String, dynamic> data) {
    return RsvpCounts(
      going: data['going'] as int? ?? 0,
      maybe: data['maybe'] as int? ?? 0,
      notGoing: data['not_going'] as int? ?? 0,
      notResponded: data['not_responded'] as int? ?? 0,
      total: data['total'] as int? ?? 0,
      plusOnes: data['plus_ones'] as int? ?? 0,
    );
  }
}

/// Guest list visibility settings
@freezed
class GuestListVisibility with _$GuestListVisibility {
  const factory GuestListVisibility({
    required String eventId,
    @Default(true) bool showGuestList,
    @Default(true) bool showRsvpCount,
    @Default(false) bool showPlusOnes,
    @Default(false) bool onlyShowConfirmed,
  }) = _GuestListVisibility;

  factory GuestListVisibility.fromJson(Map<String, dynamic> json) =>
      _$GuestListVisibilityFromJson(json);

  factory GuestListVisibility.fromSupabase(Map<String, dynamic> data) {
    return GuestListVisibility(
      eventId: data['event_id'] as String,
      showGuestList: data['show_guest_list'] as bool? ?? true,
      showRsvpCount: data['show_rsvp_count'] as bool? ?? true,
      showPlusOnes: data['show_plus_ones'] as bool? ?? false,
      onlyShowConfirmed: data['only_show_confirmed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toSupabase() {
    return {
      'event_id': eventId,
      'show_guest_list': showGuestList,
      'show_rsvp_count': showRsvpCount,
      'show_plus_ones': showPlusOnes,
      'only_show_confirmed': onlyShowConfirmed,
    };
  }
}

/// Friends attending an event
@freezed
class FriendAttending with _$FriendAttending {
  const factory FriendAttending({
    required String userId,
    required String userName,
    String? userAvatar,
    required RsvpResponse response,
    @Default(false) bool plusOneEnabled,
    DateTime? respondedAt,
  }) = _FriendAttending;

  factory FriendAttending.fromJson(Map<String, dynamic> json) =>
      _$FriendAttendingFromJson(json);

  factory FriendAttending.fromSupabase(Map<String, dynamic> data) {
    return FriendAttending(
      userId: data['user_id'] as String,
      userName: data['user_name'] as String,
      userAvatar: data['user_avatar'] as String?,
      response: RsvpResponse.values.firstWhere(
        (r) => r.name == data['response'],
        orElse: () => RsvpResponse.notResponded,
      ),
      plusOneEnabled: data['plus_one_enabled'] as bool? ?? false,
      respondedAt: data['responded_at'] != null
          ? DateTime.parse(data['responded_at'] as String)
          : null,
    );
  }
}
