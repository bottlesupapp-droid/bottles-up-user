// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refund_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RefundRequestImpl _$$RefundRequestImplFromJson(Map<String, dynamic> json) =>
    _$RefundRequestImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      bookingId: json['bookingId'] as String,
      originalAmount: (json['originalAmount'] as num).toDouble(),
      requestedAmount: (json['requestedAmount'] as num).toDouble(),
      approvedAmount: (json['approvedAmount'] as num?)?.toDouble(),
      reason: $enumDecode(_$RefundReasonEnumMap, json['reason']),
      description: json['description'] as String,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      status: $enumDecodeNullable(_$RefundStatusEnumMap, json['status']) ??
          RefundStatus.pending,
      adminNotes: json['adminNotes'] as String?,
      rejectionReason: json['rejectionReason'] as String?,
      requestedAt: DateTime.parse(json['requestedAt'] as String),
      processedAt: json['processedAt'] == null
          ? null
          : DateTime.parse(json['processedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      transactionId: json['transactionId'] as String?,
    );

Map<String, dynamic> _$$RefundRequestImplToJson(_$RefundRequestImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'bookingId': instance.bookingId,
      'originalAmount': instance.originalAmount,
      'requestedAmount': instance.requestedAmount,
      'approvedAmount': instance.approvedAmount,
      'reason': _$RefundReasonEnumMap[instance.reason]!,
      'description': instance.description,
      'attachments': instance.attachments,
      'status': _$RefundStatusEnumMap[instance.status]!,
      'adminNotes': instance.adminNotes,
      'rejectionReason': instance.rejectionReason,
      'requestedAt': instance.requestedAt.toIso8601String(),
      'processedAt': instance.processedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'transactionId': instance.transactionId,
    };

const _$RefundReasonEnumMap = {
  RefundReason.eventCancelled: 'event_cancelled',
  RefundReason.poorExperience: 'poor_experience',
  RefundReason.serviceIssue: 'service_issue',
  RefundReason.billingError: 'billing_error',
  RefundReason.personal: 'personal',
  RefundReason.other: 'other',
};

const _$RefundStatusEnumMap = {
  RefundStatus.pending: 'pending',
  RefundStatus.approved: 'approved',
  RefundStatus.rejected: 'rejected',
  RefundStatus.completed: 'completed',
};
