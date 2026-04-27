// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_modification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingModificationImpl _$$BookingModificationImplFromJson(
        Map<String, dynamic> json) =>
    _$BookingModificationImpl(
      id: json['id'] as String,
      bookingId: json['bookingId'] as String,
      userId: json['userId'] as String,
      modificationType:
          $enumDecode(_$ModificationTypeEnumMap, json['modificationType']),
      status: $enumDecode(_$ModificationStatusEnumMap, json['status']),
      oldValues: json['oldValues'] as Map<String, dynamic>?,
      newValues: json['newValues'] as Map<String, dynamic>?,
      reason: json['reason'] as String?,
      cancellationReason: $enumDecodeNullable(
          _$CancellationReasonEnumMap, json['cancellationReason']),
      refundAmount: (json['refundAmount'] as num?)?.toDouble(),
      additionalCharge: (json['additionalCharge'] as num?)?.toDouble(),
      adminNotes: json['adminNotes'] as String?,
      userNotes: json['userNotes'] as String?,
      requestedAt: DateTime.parse(json['requestedAt'] as String),
      processedAt: json['processedAt'] == null
          ? null
          : DateTime.parse(json['processedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      processedBy: json['processedBy'] as String?,
    );

Map<String, dynamic> _$$BookingModificationImplToJson(
        _$BookingModificationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bookingId': instance.bookingId,
      'userId': instance.userId,
      'modificationType': _$ModificationTypeEnumMap[instance.modificationType]!,
      'status': _$ModificationStatusEnumMap[instance.status]!,
      'oldValues': instance.oldValues,
      'newValues': instance.newValues,
      'reason': instance.reason,
      'cancellationReason':
          _$CancellationReasonEnumMap[instance.cancellationReason],
      'refundAmount': instance.refundAmount,
      'additionalCharge': instance.additionalCharge,
      'adminNotes': instance.adminNotes,
      'userNotes': instance.userNotes,
      'requestedAt': instance.requestedAt.toIso8601String(),
      'processedAt': instance.processedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'processedBy': instance.processedBy,
    };

const _$ModificationTypeEnumMap = {
  ModificationType.cancel: 'cancel',
  ModificationType.reschedule: 'reschedule',
  ModificationType.changeTable: 'change_table',
  ModificationType.changeGuests: 'change_guests',
  ModificationType.upgradeBottle: 'upgrade_bottle',
  ModificationType.addItems: 'add_items',
};

const _$ModificationStatusEnumMap = {
  ModificationStatus.pending: 'pending',
  ModificationStatus.approved: 'approved',
  ModificationStatus.rejected: 'rejected',
  ModificationStatus.completed: 'completed',
};

const _$CancellationReasonEnumMap = {
  CancellationReason.personal: 'personal',
  CancellationReason.weather: 'weather',
  CancellationReason.health: 'health',
  CancellationReason.foundBetter: 'found_better',
  CancellationReason.tooExpensive: 'too_expensive',
  CancellationReason.eventChanged: 'event_changed',
  CancellationReason.other: 'other',
};

_$CancellationPolicyImpl _$$CancellationPolicyImplFromJson(
        Map<String, dynamic> json) =>
    _$CancellationPolicyImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      hoursBeforeEvent: (json['hoursBeforeEvent'] as num).toInt(),
      refundPercentage: (json['refundPercentage'] as num).toDouble(),
      cancellationFeePercentage:
          (json['cancellationFeePercentage'] as num?)?.toDouble() ?? 0,
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$$CancellationPolicyImplToJson(
        _$CancellationPolicyImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'hoursBeforeEvent': instance.hoursBeforeEvent,
      'refundPercentage': instance.refundPercentage,
      'cancellationFeePercentage': instance.cancellationFeePercentage,
      'isActive': instance.isActive,
    };

_$RefundCalculationImpl _$$RefundCalculationImplFromJson(
        Map<String, dynamic> json) =>
    _$RefundCalculationImpl(
      originalAmount: (json['originalAmount'] as num).toDouble(),
      refundPercentage: (json['refundPercentage'] as num).toDouble(),
      refundAmount: (json['refundAmount'] as num).toDouble(),
      cancellationFee: (json['cancellationFee'] as num).toDouble(),
      netRefund: (json['netRefund'] as num).toDouble(),
      policy:
          CancellationPolicy.fromJson(json['policy'] as Map<String, dynamic>),
      hoursUntilEvent: (json['hoursUntilEvent'] as num).toInt(),
      isRefundable: json['isRefundable'] as bool,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$RefundCalculationImplToJson(
        _$RefundCalculationImpl instance) =>
    <String, dynamic>{
      'originalAmount': instance.originalAmount,
      'refundPercentage': instance.refundPercentage,
      'refundAmount': instance.refundAmount,
      'cancellationFee': instance.cancellationFee,
      'netRefund': instance.netRefund,
      'policy': instance.policy,
      'hoursUntilEvent': instance.hoursUntilEvent,
      'isRefundable': instance.isRefundable,
      'message': instance.message,
    };
