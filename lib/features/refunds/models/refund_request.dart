import 'package:freezed_annotation/freezed_annotation.dart';

part 'refund_request.freezed.dart';
part 'refund_request.g.dart';

enum RefundReason {
  @JsonValue('event_cancelled')
  eventCancelled,
  @JsonValue('poor_experience')
  poorExperience,
  @JsonValue('service_issue')
  serviceIssue,
  @JsonValue('billing_error')
  billingError,
  @JsonValue('personal')
  personal,
  @JsonValue('other')
  other,
}

enum RefundStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('approved')
  approved,
  @JsonValue('rejected')
  rejected,
  @JsonValue('completed')
  completed,
}

@freezed
class RefundRequest with _$RefundRequest {
  const factory RefundRequest({
    required String id,
    required String userId,
    required String bookingId,
    required double originalAmount,
    required double requestedAmount,
    double? approvedAmount,
    required RefundReason reason,
    required String description,
    List<String>? attachments,
    @Default(RefundStatus.pending) RefundStatus status,
    String? adminNotes,
    String? rejectionReason,
    required DateTime requestedAt,
    DateTime? processedAt,
    DateTime? completedAt,
    String? transactionId,
  }) = _RefundRequest;

  factory RefundRequest.fromJson(Map<String, dynamic> json) =>
      _$RefundRequestFromJson(json);

  factory RefundRequest.fromSupabase(Map<String, dynamic> data) {
    return RefundRequest(
      id: data['id'] as String,
      userId: data['user_id'] as String,
      bookingId: data['booking_id'] as String,
      originalAmount: (data['original_amount'] as num).toDouble(),
      requestedAmount: (data['requested_amount'] as num).toDouble(),
      approvedAmount: (data['approved_amount'] as num?)?.toDouble(),
      reason: RefundReason.values.firstWhere(
        (r) => r.name == data['reason'],
        orElse: () => RefundReason.other,
      ),
      description: data['description'] as String,
      attachments: data['attachments'] != null
          ? List<String>.from(data['attachments'] as List)
          : null,
      status: RefundStatus.values.firstWhere(
        (s) => s.name == data['status'],
        orElse: () => RefundStatus.pending,
      ),
      adminNotes: data['admin_notes'] as String?,
      rejectionReason: data['rejection_reason'] as String?,
      requestedAt: DateTime.parse(data['requested_at'] as String),
      processedAt: data['processed_at'] != null
          ? DateTime.parse(data['processed_at'] as String)
          : null,
      completedAt: data['completed_at'] != null
          ? DateTime.parse(data['completed_at'] as String)
          : null,
      transactionId: data['transaction_id'] as String?,
    );
  }
}
