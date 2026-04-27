import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_modification.freezed.dart';
part 'booking_modification.g.dart';

enum ModificationType {
  @JsonValue('cancel')
  cancel,
  @JsonValue('reschedule')
  reschedule,
  @JsonValue('change_table')
  changeTable,
  @JsonValue('change_guests')
  changeGuests,
  @JsonValue('upgrade_bottle')
  upgradeBottle,
  @JsonValue('add_items')
  addItems,
}

enum ModificationStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('approved')
  approved,
  @JsonValue('rejected')
  rejected,
  @JsonValue('completed')
  completed,
}

enum CancellationReason {
  @JsonValue('personal')
  personal,
  @JsonValue('weather')
  weather,
  @JsonValue('health')
  health,
  @JsonValue('found_better')
  foundBetter,
  @JsonValue('too_expensive')
  tooExpensive,
  @JsonValue('event_changed')
  eventChanged,
  @JsonValue('other')
  other,
}

@freezed
class BookingModification with _$BookingModification {
  const factory BookingModification({
    required String id,
    required String bookingId,
    required String userId,
    required ModificationType modificationType,
    required ModificationStatus status,
    Map<String, dynamic>? oldValues,
    Map<String, dynamic>? newValues,
    String? reason,
    CancellationReason? cancellationReason,
    double? refundAmount,
    double? additionalCharge,
    String? adminNotes,
    String? userNotes,
    required DateTime requestedAt,
    DateTime? processedAt,
    DateTime? completedAt,
    String? processedBy,
  }) = _BookingModification;

  factory BookingModification.fromJson(Map<String, dynamic> json) =>
      _$BookingModificationFromJson(json);

  factory BookingModification.fromSupabase(Map<String, dynamic> data) {
    return BookingModification(
      id: data['id'] as String,
      bookingId: data['booking_id'] as String,
      userId: data['user_id'] as String,
      modificationType: ModificationType.values.firstWhere(
        (t) => t.name == data['modification_type'],
        orElse: () => ModificationType.cancel,
      ),
      status: ModificationStatus.values.firstWhere(
        (s) => s.name == data['status'],
        orElse: () => ModificationStatus.pending,
      ),
      oldValues: data['old_values'] as Map<String, dynamic>?,
      newValues: data['new_values'] as Map<String, dynamic>?,
      reason: data['reason'] as String?,
      cancellationReason: data['cancellation_reason'] != null
          ? CancellationReason.values.firstWhere(
              (r) => r.name == data['cancellation_reason'],
              orElse: () => CancellationReason.other,
            )
          : null,
      refundAmount: (data['refund_amount'] as num?)?.toDouble(),
      additionalCharge: (data['additional_charge'] as num?)?.toDouble(),
      adminNotes: data['admin_notes'] as String?,
      userNotes: data['user_notes'] as String?,
      requestedAt: DateTime.parse(data['requested_at'] as String),
      processedAt: data['processed_at'] != null
          ? DateTime.parse(data['processed_at'] as String)
          : null,
      completedAt: data['completed_at'] != null
          ? DateTime.parse(data['completed_at'] as String)
          : null,
      processedBy: data['processed_by'] as String?,
    );
  }

  Map<String, dynamic> toSupabase() {
    return {
      'booking_id': bookingId,
      'user_id': userId,
      'modification_type': modificationType.name,
      'status': status.name,
      'old_values': oldValues,
      'new_values': newValues,
      'reason': reason,
      'cancellation_reason': cancellationReason?.name,
      'refund_amount': refundAmount,
      'additional_charge': additionalCharge,
      'user_notes': userNotes,
    };
  }
}

@freezed
class CancellationPolicy with _$CancellationPolicy {
  const factory CancellationPolicy({
    required String id,
    required String name,
    required String description,
    required int hoursBeforeEvent,
    required double refundPercentage,
    @Default(0) double cancellationFeePercentage,
    @Default(true) bool isActive,
  }) = _CancellationPolicy;

  factory CancellationPolicy.fromJson(Map<String, dynamic> json) =>
      _$CancellationPolicyFromJson(json);

  factory CancellationPolicy.fromSupabase(Map<String, dynamic> data) {
    return CancellationPolicy(
      id: data['id'] as String,
      name: data['name'] as String,
      description: data['description'] as String,
      hoursBeforeEvent: data['hours_before_event'] as int,
      refundPercentage: (data['refund_percentage'] as num).toDouble(),
      cancellationFeePercentage:
          (data['cancellation_fee_percentage'] as num?)?.toDouble() ?? 0,
      isActive: data['is_active'] as bool? ?? true,
    );
  }

  // Standard policies
  static const CancellationPolicy flexible = CancellationPolicy(
    id: 'flexible',
    name: 'Flexible',
    description: '24 hours before event - 100% refund',
    hoursBeforeEvent: 24,
    refundPercentage: 100,
  );

  static const CancellationPolicy moderate = CancellationPolicy(
    id: 'moderate',
    name: 'Moderate',
    description: '72 hours - 100%, 24 hours - 50%, Less - 0%',
    hoursBeforeEvent: 72,
    refundPercentage: 100,
  );

  static const CancellationPolicy strict = CancellationPolicy(
    id: 'strict',
    name: 'Strict',
    description: '7 days - 100%, 3 days - 50%, Less - 0%',
    hoursBeforeEvent: 168, // 7 days
    refundPercentage: 100,
  );
}

@freezed
class RefundCalculation with _$RefundCalculation {
  const factory RefundCalculation({
    required double originalAmount,
    required double refundPercentage,
    required double refundAmount,
    required double cancellationFee,
    required double netRefund,
    required CancellationPolicy policy,
    required int hoursUntilEvent,
    required bool isRefundable,
    String? message,
  }) = _RefundCalculation;

  factory RefundCalculation.fromJson(Map<String, dynamic> json) =>
      _$RefundCalculationFromJson(json);
}
