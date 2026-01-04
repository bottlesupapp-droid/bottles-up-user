import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_rsvp.freezed.dart';
part 'event_rsvp.g.dart';

enum RsvpType {
  @JsonValue('guestlist')
  guestlist,
  @JsonValue('table')
  table,
}

@freezed
class EventRSVP with _$EventRSVP {
  const factory EventRSVP({
    required String id,
    required String eventId,
    required String userId,
    required RsvpType rsvpType,
    required String firstName,
    required String lastName,
    required String email,
    String? phone,
    String? specialRequests,
    @Default('pending') String status,
    @Default(false) bool isAttended,
    String? verificationCode,
    String? qrCodeData,
    DateTime? verifiedAt,
    String? verifiedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _EventRSVP;

  factory EventRSVP.fromJson(Map<String, dynamic> json) => _$EventRSVPFromJson(json);

  factory EventRSVP.fromSupabase(Map<String, dynamic> data) {
    return EventRSVP(
      id: data['id'],
      eventId: data['event_id'],
      userId: data['user_id'],
      rsvpType: RsvpType.values.firstWhere(
        (type) => type.name == data['rsvp_type'],
        orElse: () => RsvpType.guestlist,
      ),
      firstName: data['first_name'],
      lastName: data['last_name'],
      email: data['email'],
      phone: data['phone'],
      specialRequests: data['special_requests'],
      status: data['status'] ?? 'pending',
      isAttended: data['is_attended'] ?? false,
      verificationCode: data['verification_code'],
      qrCodeData: data['qr_code_data'],
      verifiedAt: data['verified_at'] != null ? DateTime.parse(data['verified_at']) : null,
      verifiedBy: data['verified_by'],
      createdAt: data['created_at'] != null ? DateTime.parse(data['created_at']) : null,
      updatedAt: data['updated_at'] != null ? DateTime.parse(data['updated_at']) : null,
    );
  }
}

@freezed
class EventTableBooking with _$EventTableBooking {
  const factory EventTableBooking({
    required String id,
    required String eventId,
    required String userId,
    required String tableId,
    required int partySize,
    required double depositAmount,
    required int minimumBottles,
    @Default('pending') String status,
    @Default(false) bool depositPaid,
    DateTime? eventDate,
    String? specialRequests,
    List<SplitPaymentParticipant>? splitPayments,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _EventTableBooking;

  factory EventTableBooking.fromJson(Map<String, dynamic> json) => _$EventTableBookingFromJson(json);

  factory EventTableBooking.fromSupabase(Map<String, dynamic> data) {
    return EventTableBooking(
      id: data['id'],
      eventId: data['event_id'],
      userId: data['user_id'],
      tableId: data['table_id'],
      partySize: data['guest_count'] ?? data['party_size'] ?? 0,
      depositAmount: (data['deposit_amount'] as num).toDouble(),
      minimumBottles: data['bottle_minimum'] ?? data['minimum_bottles'] ?? 0,
      status: data['status'] ?? 'pending',
      depositPaid: data['payment_status'] == 'paid' || data['deposit_paid'] == true,
      eventDate: data['event_date'] != null ? DateTime.parse(data['event_date']) : null,
      specialRequests: data['special_requests'],
      splitPayments: data['split_payments'] != null
          ? (data['split_payments'] as List)
              .map((item) => SplitPaymentParticipant.fromSupabase(item))
              .toList()
          : null,
      createdAt: data['created_at'] != null ? DateTime.parse(data['created_at']) : null,
      updatedAt: data['updated_at'] != null ? DateTime.parse(data['updated_at']) : null,
    );
  }
}

@freezed
class SplitPaymentParticipant with _$SplitPaymentParticipant {
  const factory SplitPaymentParticipant({
    required String id,
    required String tableBookingId,
    required String participantName,
    required String email,
    required double amount,
    @Default('pending') String paymentStatus,
    String? paymentIntentId,
    DateTime? paidAt,
    DateTime? createdAt,
  }) = _SplitPaymentParticipant;

  factory SplitPaymentParticipant.fromJson(Map<String, dynamic> json) => _$SplitPaymentParticipantFromJson(json);

  factory SplitPaymentParticipant.fromSupabase(Map<String, dynamic> data) {
    return SplitPaymentParticipant(
      id: data['id'],
      tableBookingId: data['table_booking_id'],
      participantName: data['participant_name'],
      email: data['email'],
      amount: (data['amount'] as num).toDouble(),
      paymentStatus: data['payment_status'] ?? 'pending',
      paymentIntentId: data['payment_intent_id'],
      paidAt: data['paid_at'] != null ? DateTime.parse(data['paid_at']) : null,
      createdAt: data['created_at'] != null ? DateTime.parse(data['created_at']) : null,
    );
  }
}

@freezed
class EventConfiguration with _$EventConfiguration {
  const factory EventConfiguration({
    required String id,
    required String eventId,
    @Default(true) bool enableGuestlistRsvp,
    @Default(true) bool enableTableBooking,
    @Default(50.0) double minTableDeposit,
    @Default(200.0) double maxTableDeposit,
    @Default(2) int minBottleRequirement,
    @Default(10) int maxPartySize,
    @Default(0.07) double serviceFeeRate,
    @Default(0.13) double taxRate,
    List<String>? availableTableIds,
    Map<String, dynamic>? tableConfiguration,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _EventConfiguration;

  factory EventConfiguration.fromJson(Map<String, dynamic> json) => _$EventConfigurationFromJson(json);

  factory EventConfiguration.fromSupabase(Map<String, dynamic> data) {
    return EventConfiguration(
      id: data['id'],
      eventId: data['event_id'],
      enableGuestlistRsvp: data['enable_guestlist_rsvp'] ?? true,
      enableTableBooking: data['enable_table_booking'] ?? true,
      minTableDeposit: (data['min_table_deposit'] as num?)?.toDouble() ?? 50.0,
      maxTableDeposit: (data['max_table_deposit'] as num?)?.toDouble() ?? 200.0,
      minBottleRequirement: data['min_bottle_requirement'] ?? 2,
      maxPartySize: data['max_party_size'] ?? 10,
      serviceFeeRate: (data['service_fee_rate'] as num?)?.toDouble() ?? 0.07,
      taxRate: (data['tax_rate'] as num?)?.toDouble() ?? 0.13,
      availableTableIds: data['available_table_ids'] != null
          ? List<String>.from(data['available_table_ids'])
          : null,
      tableConfiguration: data['table_configuration'],
      createdAt: data['created_at'] != null ? DateTime.parse(data['created_at']) : null,
      updatedAt: data['updated_at'] != null ? DateTime.parse(data['updated_at']) : null,
    );
  }
}