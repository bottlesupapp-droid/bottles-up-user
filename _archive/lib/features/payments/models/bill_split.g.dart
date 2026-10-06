// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_split.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BillSplitImpl _$$BillSplitImplFromJson(Map<String, dynamic> json) =>
    _$BillSplitImpl(
      id: json['id'] as String,
      bookingId: json['bookingId'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      splitMethod: $enumDecode(_$SplitMethodEnumMap, json['splitMethod']),
      status: $enumDecodeNullable(_$SplitStatusEnumMap, json['status']) ??
          SplitStatus.active,
      participants: (json['participants'] as List<dynamic>?)
              ?.map((e) => BillParticipant.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$$BillSplitImplToJson(_$BillSplitImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bookingId': instance.bookingId,
      'totalAmount': instance.totalAmount,
      'splitMethod': _$SplitMethodEnumMap[instance.splitMethod]!,
      'status': _$SplitStatusEnumMap[instance.status]!,
      'participants': instance.participants,
      'createdAt': instance.createdAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
    };

const _$SplitMethodEnumMap = {
  SplitMethod.equal: 'equal',
  SplitMethod.custom: 'custom',
  SplitMethod.percentage: 'percentage',
  SplitMethod.itemized: 'itemized',
};

const _$SplitStatusEnumMap = {
  SplitStatus.active: 'active',
  SplitStatus.completed: 'completed',
  SplitStatus.cancelled: 'cancelled',
};

_$BillParticipantImpl _$$BillParticipantImplFromJson(
        Map<String, dynamic> json) =>
    _$BillParticipantImpl(
      id: json['id'] as String,
      billSplitId: json['billSplitId'] as String,
      userId: json['userId'] as String?,
      userName: json['userName'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      amountOwed: (json['amountOwed'] as num).toDouble(),
      amountPaid: (json['amountPaid'] as num?)?.toDouble(),
      status: $enumDecodeNullable(_$ParticipantStatusEnumMap, json['status']) ??
          ParticipantStatus.pending,
      paymentIntentId: json['paymentIntentId'] as String?,
      paymentUrl: json['paymentUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      paidAt: json['paidAt'] == null
          ? null
          : DateTime.parse(json['paidAt'] as String),
    );

Map<String, dynamic> _$$BillParticipantImplToJson(
        _$BillParticipantImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'billSplitId': instance.billSplitId,
      'userId': instance.userId,
      'userName': instance.userName,
      'email': instance.email,
      'phone': instance.phone,
      'amountOwed': instance.amountOwed,
      'amountPaid': instance.amountPaid,
      'status': _$ParticipantStatusEnumMap[instance.status]!,
      'paymentIntentId': instance.paymentIntentId,
      'paymentUrl': instance.paymentUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'paidAt': instance.paidAt?.toIso8601String(),
    };

const _$ParticipantStatusEnumMap = {
  ParticipantStatus.pending: 'pending',
  ParticipantStatus.paid: 'paid',
  ParticipantStatus.declined: 'declined',
};

_$BillItemImpl _$$BillItemImplFromJson(Map<String, dynamic> json) =>
    _$BillItemImpl(
      id: json['id'] as String,
      billSplitId: json['billSplitId'] as String,
      itemName: json['itemName'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      assignedToUserIds: (json['assignedToUserIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$BillItemImplToJson(_$BillItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'billSplitId': instance.billSplitId,
      'itemName': instance.itemName,
      'price': instance.price,
      'quantity': instance.quantity,
      'assignedToUserIds': instance.assignedToUserIds,
    };
