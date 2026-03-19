import 'package:freezed_annotation/freezed_annotation.dart';

part 'ticket_transfer.freezed.dart';
part 'ticket_transfer.g.dart';

@freezed
class TicketTransfer with _$TicketTransfer {
  const factory TicketTransfer({
    required String id,
    required String ticketId,
    required String fromUserId,
    required String toUserId,
    @Default('pending') String status,
    String? message,
    DateTime? transferredAt,
    DateTime? expiresAt,
    DateTime? createdAt,

    // Joined data
    String? fromUserName,
    String? fromUserEmail,
    String? toUserName,
    String? toUserEmail,
    String? eventName,
    String? eventDate,
  }) = _TicketTransfer;

  factory TicketTransfer.fromJson(Map<String, dynamic> json) => _$TicketTransferFromJson(json);

  factory TicketTransfer.fromSupabase(Map<String, dynamic> data) {
    return TicketTransfer(
      id: data['id'] as String,
      ticketId: data['ticket_id'] as String,
      fromUserId: data['from_user_id'] as String,
      toUserId: data['to_user_id'] as String,
      status: data['status'] as String? ?? 'pending',
      message: data['message'] as String?,
      transferredAt: data['transferred_at'] != null ? DateTime.parse(data['transferred_at'] as String) : null,
      expiresAt: data['expires_at'] != null ? DateTime.parse(data['expires_at'] as String) : null,
      createdAt: data['created_at'] != null ? DateTime.parse(data['created_at'] as String) : null,
      fromUserName: data['from_user_name'] as String?,
      fromUserEmail: data['from_user_email'] as String?,
      toUserName: data['to_user_name'] as String?,
      toUserEmail: data['to_user_email'] as String?,
      eventName: data['event_name'] as String?,
      eventDate: data['event_date'] as String?,
    );
  }
}

extension TicketTransferX on TicketTransfer {
  bool get isPending => status == 'pending';
  bool get isAccepted => status == 'accepted';
  bool get isRejected => status == 'rejected';
  bool get isExpired => expiresAt != null && expiresAt!.isBefore(DateTime.now());
}
