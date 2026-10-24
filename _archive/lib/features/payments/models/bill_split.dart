import 'package:freezed_annotation/freezed_annotation.dart';

part 'bill_split.freezed.dart';
part 'bill_split.g.dart';

enum SplitMethod {
  equal,
  custom,
  percentage,
  itemized,
}

enum SplitStatus {
  active,
  completed,
  cancelled,
}

enum ParticipantStatus {
  pending,
  paid,
  declined,
}

@freezed
class BillSplit with _$BillSplit {
  const factory BillSplit({
    required String id,
    required String bookingId,
    required double totalAmount,
    required SplitMethod splitMethod,
    @Default(SplitStatus.active) SplitStatus status,
    @Default([]) List<BillParticipant> participants,
    required DateTime createdAt,
    DateTime? completedAt,
  }) = _BillSplit;

  factory BillSplit.fromJson(Map<String, dynamic> json) =>
      _$BillSplitFromJson(json);

  factory BillSplit.fromSupabase(Map<String, dynamic> data) {
    return BillSplit(
      id: data['id'] as String,
      bookingId: data['booking_id'] as String,
      totalAmount: (data['total_amount'] as num).toDouble(),
      splitMethod: SplitMethod.values.firstWhere(
        (e) => e.name == data['split_method'],
        orElse: () => SplitMethod.equal,
      ),
      status: SplitStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => SplitStatus.active,
      ),
      participants: data['participants'] != null
          ? (data['participants'] as List)
              .map((p) => BillParticipant.fromSupabase(p as Map<String, dynamic>))
              .toList()
          : [],
      createdAt: DateTime.parse(data['created_at'] as String),
      completedAt: data['completed_at'] != null
          ? DateTime.parse(data['completed_at'] as String)
          : null,
    );
  }
}

@freezed
class BillParticipant with _$BillParticipant {
  const factory BillParticipant({
    required String id,
    required String billSplitId,
    String? userId,
    String? userName,
    String? email,
    String? phone,
    required double amountOwed,
    double? amountPaid,
    @Default(ParticipantStatus.pending) ParticipantStatus status,
    String? paymentIntentId,
    String? paymentUrl,
    required DateTime createdAt,
    DateTime? paidAt,
  }) = _BillParticipant;

  factory BillParticipant.fromJson(Map<String, dynamic> json) =>
      _$BillParticipantFromJson(json);

  factory BillParticipant.fromSupabase(Map<String, dynamic> data) {
    return BillParticipant(
      id: data['id'] as String,
      billSplitId: data['bill_split_id'] as String,
      userId: data['user_id'] as String?,
      userName: data['user_name'] as String?,
      email: data['email'] as String?,
      phone: data['phone'] as String?,
      amountOwed: (data['amount_owed'] as num).toDouble(),
      amountPaid: (data['amount_paid'] as num?)?.toDouble(),
      status: ParticipantStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => ParticipantStatus.pending,
      ),
      paymentIntentId: data['payment_intent_id'] as String?,
      paymentUrl: data['payment_url'] as String?,
      createdAt: DateTime.parse(data['created_at'] as String),
      paidAt: data['paid_at'] != null
          ? DateTime.parse(data['paid_at'] as String)
          : null,
    );
  }
}

@freezed
class BillItem with _$BillItem {
  const factory BillItem({
    required String id,
    required String billSplitId,
    required String itemName,
    required double price,
    @Default(1) int quantity,
    @Default([]) List<String> assignedToUserIds,
  }) = _BillItem;

  factory BillItem.fromJson(Map<String, dynamic> json) =>
      _$BillItemFromJson(json);

  factory BillItem.fromSupabase(Map<String, dynamic> data) {
    return BillItem(
      id: data['id'] as String,
      billSplitId: data['bill_split_id'] as String,
      itemName: data['item_name'] as String,
      price: (data['price'] as num).toDouble(),
      quantity: data['quantity'] as int? ?? 1,
      assignedToUserIds: data['assigned_to_user_ids'] != null
          ? List<String>.from(data['assigned_to_user_ids'] as List)
          : [],
    );
  }
}
