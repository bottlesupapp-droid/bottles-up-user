import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_pass.freezed.dart';
part 'wallet_pass.g.dart';

/// Model representing an Apple Wallet pass for event tickets
@freezed
class WalletPass with _$WalletPass {
  const factory WalletPass({
    required String id,
    required String eventId,
    required String userId,
    required String bookingId,
    required String passType, // 'rsvp' or 'table_booking'
    required String eventName,
    required String venueName,
    required DateTime eventDate,
    required String eventTime,
    String? qrCodeData,
    String? verificationCode,
    String? tableNumber,
    int? partySize,
    String? passUrl,
    DateTime? createdAt,
  }) = _WalletPass;

  factory WalletPass.fromJson(Map<String, dynamic> json) => _$WalletPassFromJson(json);

  factory WalletPass.fromSupabase(Map<String, dynamic> data) {
    return WalletPass(
      id: data['id'] as String,
      eventId: data['event_id'] as String,
      userId: data['user_id'] as String,
      bookingId: data['booking_id'] as String,
      passType: data['pass_type'] as String,
      eventName: data['event_name'] as String,
      venueName: data['venue_name'] as String,
      eventDate: DateTime.parse(data['event_date'] as String),
      eventTime: data['event_time'] as String,
      qrCodeData: data['qr_code_data'] as String?,
      verificationCode: data['verification_code'] as String?,
      tableNumber: data['table_number'] as String?,
      partySize: data['party_size'] as int?,
      passUrl: data['pass_url'] as String?,
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at'] as String)
          : null,
    );
  }
}

extension WalletPassX on WalletPass {
  /// Check if this is a table booking pass
  bool get isTableBooking => passType == 'table_booking';

  /// Check if this is an RSVP pass
  bool get isRsvp => passType == 'rsvp';

  /// Get display title for the pass
  String get displayTitle => isTableBooking ? 'Table Reservation' : 'Guestlist RSVP';

  /// Get formatted party size text
  String get partySizeText => partySize != null ? '$partySize guests' : '';
}
