import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_models.freezed.dart';
part 'payment_models.g.dart';

@freezed
class PaymentIntent with _$PaymentIntent {
  const factory PaymentIntent({
    required String id,
    @JsonKey(name: 'client_secret') required String clientSecret,
    required double amount,
    required String currency,
    required String status,
    String? description,
    Map<String, dynamic>? metadata,
    @JsonKey(name: 'created') required int createdTimestamp,
  }) = _PaymentIntent;

  factory PaymentIntent.fromJson(Map<String, dynamic> json) =>
      _$PaymentIntentFromJson(json);
}

@freezed
class PaymentMethodInfo with _$PaymentMethodInfo {
  const factory PaymentMethodInfo({
    required String id,
    required String type,
    PaymentMethodCard? card,
    PaymentMethodBillingDetails? billingDetails,
    @JsonKey(name: 'created') required int createdTimestamp,
  }) = _PaymentMethodInfo;

  factory PaymentMethodInfo.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodInfoFromJson(json);
}

@freezed
class PaymentMethodCard with _$PaymentMethodCard {
  const factory PaymentMethodCard({
    required String brand,
    required String country,
    @JsonKey(name: 'exp_month') required int expMonth,
    @JsonKey(name: 'exp_year') required int expYear,
    required String funding,
    @JsonKey(name: 'last4') required String last4,
  }) = _PaymentMethodCard;

  factory PaymentMethodCard.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodCardFromJson(json);
}

@freezed
class PaymentMethodBillingDetails with _$PaymentMethodBillingDetails {
  const factory PaymentMethodBillingDetails({
    String? email,
    String? name,
    String? phone,
    PaymentMethodAddress? address,
  }) = _PaymentMethodBillingDetails;

  factory PaymentMethodBillingDetails.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodBillingDetailsFromJson(json);
}

@freezed
class PaymentMethodAddress with _$PaymentMethodAddress {
  const factory PaymentMethodAddress({
    String? city,
    String? country,
    String? line1,
    String? line2,
    @JsonKey(name: 'postal_code') String? postalCode,
    String? state,
  }) = _PaymentMethodAddress;

  factory PaymentMethodAddress.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodAddressFromJson(json);
}

@freezed
class StripeCustomer with _$StripeCustomer {
  const factory StripeCustomer({
    required String id,
    required String email,
    String? name,
    String? phone,
    @JsonKey(name: 'created') required int createdTimestamp,
    Map<String, dynamic>? metadata,
  }) = _StripeCustomer;

  factory StripeCustomer.fromJson(Map<String, dynamic> json) =>
      _$StripeCustomerFromJson(json);
}

enum PaymentStatus {
  @JsonValue('requires_payment_method')
  requiresPaymentMethod,
  @JsonValue('requires_confirmation')
  requiresConfirmation,
  @JsonValue('requires_action')
  requiresAction,
  @JsonValue('processing')
  processing,
  @JsonValue('requires_capture')
  requiresCapture,
  @JsonValue('canceled')
  canceled,
  @JsonValue('succeeded')
  succeeded,
}

enum PaymentType {
  tableBooking,
  eventTicket,
  bottleService,
  membership,
}

@freezed
class BookingPayment with _$BookingPayment {
  const factory BookingPayment({
    required String id,
    required String userId,
    required String bookingId,
    required PaymentType type,
    required double amount,
    required String currency,
    required PaymentStatus status,
    String? stripePaymentIntentId,
    String? stripeCustomerId,
    Map<String, dynamic>? metadata,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _BookingPayment;

  factory BookingPayment.fromJson(Map<String, dynamic> json) =>
      _$BookingPaymentFromJson(json);
}