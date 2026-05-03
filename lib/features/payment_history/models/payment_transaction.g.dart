// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentTransactionImpl _$$PaymentTransactionImplFromJson(
        Map<String, dynamic> json) =>
    _$PaymentTransactionImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      bookingId: json['bookingId'] as String?,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      status: $enumDecode(_$PaymentStatusEnumMap, json['status']),
      method: $enumDecode(_$PaymentMethodEnumMap, json['method']),
      paymentIntentId: json['paymentIntentId'] as String?,
      receiptUrl: json['receiptUrl'] as String?,
      description: json['description'] as String?,
      refundedAmount: (json['refundedAmount'] as num?)?.toDouble(),
      refundedAt: json['refundedAt'] == null
          ? null
          : DateTime.parse(json['refundedAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$PaymentTransactionImplToJson(
        _$PaymentTransactionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'bookingId': instance.bookingId,
      'amount': instance.amount,
      'currency': instance.currency,
      'status': _$PaymentStatusEnumMap[instance.status]!,
      'method': _$PaymentMethodEnumMap[instance.method]!,
      'paymentIntentId': instance.paymentIntentId,
      'receiptUrl': instance.receiptUrl,
      'description': instance.description,
      'refundedAmount': instance.refundedAmount,
      'refundedAt': instance.refundedAt?.toIso8601String(),
      'metadata': instance.metadata,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 'pending',
  PaymentStatus.processing: 'processing',
  PaymentStatus.completed: 'completed',
  PaymentStatus.failed: 'failed',
  PaymentStatus.refunded: 'refunded',
  PaymentStatus.partiallyRefunded: 'partiallyRefunded',
};

const _$PaymentMethodEnumMap = {
  PaymentMethod.card: 'card',
  PaymentMethod.applePay: 'applePay',
  PaymentMethod.googlePay: 'googlePay',
  PaymentMethod.paypal: 'paypal',
  PaymentMethod.bankTransfer: 'bankTransfer',
  PaymentMethod.cash: 'cash',
};

_$PaymentFilterImpl _$$PaymentFilterImplFromJson(Map<String, dynamic> json) =>
    _$PaymentFilterImpl(
      dateRange: json['dateRange'] == null
          ? null
          : DateTimeRange.fromJson(json['dateRange'] as Map<String, dynamic>),
      statuses: (json['statuses'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$PaymentStatusEnumMap, e))
          .toList(),
      methods: (json['methods'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$PaymentMethodEnumMap, e))
          .toList(),
      minAmount: (json['minAmount'] as num?)?.toDouble(),
      maxAmount: (json['maxAmount'] as num?)?.toDouble(),
      searchQuery: json['searchQuery'] as String?,
    );

Map<String, dynamic> _$$PaymentFilterImplToJson(_$PaymentFilterImpl instance) =>
    <String, dynamic>{
      'dateRange': instance.dateRange,
      'statuses':
          instance.statuses?.map((e) => _$PaymentStatusEnumMap[e]!).toList(),
      'methods':
          instance.methods?.map((e) => _$PaymentMethodEnumMap[e]!).toList(),
      'minAmount': instance.minAmount,
      'maxAmount': instance.maxAmount,
      'searchQuery': instance.searchQuery,
    };

_$DateTimeRangeImpl _$$DateTimeRangeImplFromJson(Map<String, dynamic> json) =>
    _$DateTimeRangeImpl(
      start: DateTime.parse(json['start'] as String),
      end: DateTime.parse(json['end'] as String),
    );

Map<String, dynamic> _$$DateTimeRangeImplToJson(_$DateTimeRangeImpl instance) =>
    <String, dynamic>{
      'start': instance.start.toIso8601String(),
      'end': instance.end.toIso8601String(),
    };
