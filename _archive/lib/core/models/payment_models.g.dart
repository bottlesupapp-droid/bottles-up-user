// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentIntentImpl _$$PaymentIntentImplFromJson(Map<String, dynamic> json) =>
    _$PaymentIntentImpl(
      id: json['id'] as String,
      clientSecret: json['client_secret'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      status: json['status'] as String,
      description: json['description'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdTimestamp: (json['created'] as num).toInt(),
    );

Map<String, dynamic> _$$PaymentIntentImplToJson(_$PaymentIntentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'client_secret': instance.clientSecret,
      'amount': instance.amount,
      'currency': instance.currency,
      'status': instance.status,
      'description': instance.description,
      'metadata': instance.metadata,
      'created': instance.createdTimestamp,
    };

_$PaymentMethodInfoImpl _$$PaymentMethodInfoImplFromJson(
        Map<String, dynamic> json) =>
    _$PaymentMethodInfoImpl(
      id: json['id'] as String,
      type: json['type'] as String,
      card: json['card'] == null
          ? null
          : PaymentMethodCard.fromJson(json['card'] as Map<String, dynamic>),
      billingDetails: json['billingDetails'] == null
          ? null
          : PaymentMethodBillingDetails.fromJson(
              json['billingDetails'] as Map<String, dynamic>),
      createdTimestamp: (json['created'] as num).toInt(),
    );

Map<String, dynamic> _$$PaymentMethodInfoImplToJson(
        _$PaymentMethodInfoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'card': instance.card,
      'billingDetails': instance.billingDetails,
      'created': instance.createdTimestamp,
    };

_$PaymentMethodCardImpl _$$PaymentMethodCardImplFromJson(
        Map<String, dynamic> json) =>
    _$PaymentMethodCardImpl(
      brand: json['brand'] as String,
      country: json['country'] as String,
      expMonth: (json['exp_month'] as num).toInt(),
      expYear: (json['exp_year'] as num).toInt(),
      funding: json['funding'] as String,
      last4: json['last4'] as String,
    );

Map<String, dynamic> _$$PaymentMethodCardImplToJson(
        _$PaymentMethodCardImpl instance) =>
    <String, dynamic>{
      'brand': instance.brand,
      'country': instance.country,
      'exp_month': instance.expMonth,
      'exp_year': instance.expYear,
      'funding': instance.funding,
      'last4': instance.last4,
    };

_$PaymentMethodBillingDetailsImpl _$$PaymentMethodBillingDetailsImplFromJson(
        Map<String, dynamic> json) =>
    _$PaymentMethodBillingDetailsImpl(
      email: json['email'] as String?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] == null
          ? null
          : PaymentMethodAddress.fromJson(
              json['address'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PaymentMethodBillingDetailsImplToJson(
        _$PaymentMethodBillingDetailsImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'name': instance.name,
      'phone': instance.phone,
      'address': instance.address,
    };

_$PaymentMethodAddressImpl _$$PaymentMethodAddressImplFromJson(
        Map<String, dynamic> json) =>
    _$PaymentMethodAddressImpl(
      city: json['city'] as String?,
      country: json['country'] as String?,
      line1: json['line1'] as String?,
      line2: json['line2'] as String?,
      postalCode: json['postal_code'] as String?,
      state: json['state'] as String?,
    );

Map<String, dynamic> _$$PaymentMethodAddressImplToJson(
        _$PaymentMethodAddressImpl instance) =>
    <String, dynamic>{
      'city': instance.city,
      'country': instance.country,
      'line1': instance.line1,
      'line2': instance.line2,
      'postal_code': instance.postalCode,
      'state': instance.state,
    };

_$StripeCustomerImpl _$$StripeCustomerImplFromJson(Map<String, dynamic> json) =>
    _$StripeCustomerImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      createdTimestamp: (json['created'] as num).toInt(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$StripeCustomerImplToJson(
        _$StripeCustomerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'phone': instance.phone,
      'created': instance.createdTimestamp,
      'metadata': instance.metadata,
    };

_$BookingPaymentImpl _$$BookingPaymentImplFromJson(Map<String, dynamic> json) =>
    _$BookingPaymentImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      bookingId: json['bookingId'] as String,
      type: $enumDecode(_$PaymentTypeEnumMap, json['type']),
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      status: $enumDecode(_$PaymentStatusEnumMap, json['status']),
      stripePaymentIntentId: json['stripePaymentIntentId'] as String?,
      stripeCustomerId: json['stripeCustomerId'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$BookingPaymentImplToJson(
        _$BookingPaymentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'bookingId': instance.bookingId,
      'type': _$PaymentTypeEnumMap[instance.type]!,
      'amount': instance.amount,
      'currency': instance.currency,
      'status': _$PaymentStatusEnumMap[instance.status]!,
      'stripePaymentIntentId': instance.stripePaymentIntentId,
      'stripeCustomerId': instance.stripeCustomerId,
      'metadata': instance.metadata,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$PaymentTypeEnumMap = {
  PaymentType.tableBooking: 'tableBooking',
  PaymentType.eventTicket: 'eventTicket',
  PaymentType.bottleService: 'bottleService',
  PaymentType.membership: 'membership',
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.requiresPaymentMethod: 'requires_payment_method',
  PaymentStatus.requiresConfirmation: 'requires_confirmation',
  PaymentStatus.requiresAction: 'requires_action',
  PaymentStatus.processing: 'processing',
  PaymentStatus.requiresCapture: 'requires_capture',
  PaymentStatus.canceled: 'canceled',
  PaymentStatus.succeeded: 'succeeded',
};
