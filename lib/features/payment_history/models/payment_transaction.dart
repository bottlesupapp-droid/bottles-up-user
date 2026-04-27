import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_transaction.freezed.dart';
part 'payment_transaction.g.dart';

enum PaymentStatus {
  pending,
  processing,
  completed,
  failed,
  refunded,
  partiallyRefunded,
}

enum PaymentMethod {
  card,
  applePay,
  googlePay,
  paypal,
  bankTransfer,
  cash,
}

@freezed
class PaymentTransaction with _$PaymentTransaction {
  const factory PaymentTransaction({
    required String id,
    required String userId,
    String? bookingId,
    required double amount,
    required String currency,
    required PaymentStatus status,
    required PaymentMethod method,
    String? paymentIntentId,
    String? receiptUrl,
    String? description,
    double? refundedAmount,
    DateTime? refundedAt,
    Map<String, dynamic>? metadata,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _PaymentTransaction;

  factory PaymentTransaction.fromJson(Map<String, dynamic> json) =>
      _$PaymentTransactionFromJson(json);

  factory PaymentTransaction.fromSupabase(Map<String, dynamic> data) {
    return PaymentTransaction(
      id: data['id'] as String,
      userId: data['user_id'] as String,
      bookingId: data['booking_id'] as String?,
      amount: (data['amount'] as num).toDouble(),
      currency: data['currency'] as String? ?? 'USD',
      status: PaymentStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => PaymentStatus.pending,
      ),
      method: PaymentMethod.values.firstWhere(
        (e) => e.name == data['method'],
        orElse: () => PaymentMethod.card,
      ),
      paymentIntentId: data['payment_intent_id'] as String?,
      receiptUrl: data['receipt_url'] as String?,
      description: data['description'] as String?,
      refundedAmount: (data['refunded_amount'] as num?)?.toDouble(),
      refundedAt: data['refunded_at'] != null
          ? DateTime.parse(data['refunded_at'] as String)
          : null,
      metadata: data['metadata'] != null
          ? Map<String, dynamic>.from(data['metadata'] as Map)
          : null,
      createdAt: DateTime.parse(data['created_at'] as String),
      updatedAt: data['updated_at'] != null
          ? DateTime.parse(data['updated_at'] as String)
          : null,
    );
  }
}

@freezed
class PaymentFilter with _$PaymentFilter {
  const factory PaymentFilter({
    DateTimeRange? dateRange,
    List<PaymentStatus>? statuses,
    List<PaymentMethod>? methods,
    double? minAmount,
    double? maxAmount,
    String? searchQuery,
  }) = _PaymentFilter;

  factory PaymentFilter.fromJson(Map<String, dynamic> json) =>
      _$PaymentFilterFromJson(json);
}

@freezed
class DateTimeRange with _$DateTimeRange {
  const factory DateTimeRange({
    required DateTime start,
    required DateTime end,
  }) = _DateTimeRange;

  factory DateTimeRange.fromJson(Map<String, dynamic> json) =>
      _$DateTimeRangeFromJson(json);
}
