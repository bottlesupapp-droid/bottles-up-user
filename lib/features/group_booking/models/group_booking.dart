import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_booking.freezed.dart';
part 'group_booking.g.dart';

enum GroupBookingStatus {
  pending,
  confirmed,
  cancelled,
  completed,
}

enum MemberStatus {
  invited,
  accepted,
  declined,
  paid,
}

@freezed
class GroupBooking with _$GroupBooking {
  const factory GroupBooking({
    required String id,
    required String organizerId,
    required String organizerName,
    required String eventId,
    required String eventName,
    required int maxMembers,
    required int currentMembers,
    required double totalAmount,
    required double amountPerPerson,
    @Default(GroupBookingStatus.pending) GroupBookingStatus status,
    DateTime? confirmationDeadline,
    String? specialRequests,
    @Default([]) List<GroupMember> members,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _GroupBooking;

  factory GroupBooking.fromJson(Map<String, dynamic> json) =>
      _$GroupBookingFromJson(json);

  factory GroupBooking.fromSupabase(Map<String, dynamic> data) {
    return GroupBooking(
      id: data['id'] as String,
      organizerId: data['organizer_id'] as String,
      organizerName: data['organizer_name'] as String,
      eventId: data['event_id'] as String,
      eventName: data['event_name'] as String,
      maxMembers: data['max_members'] as int,
      currentMembers: data['current_members'] as int,
      totalAmount: (data['total_amount'] as num).toDouble(),
      amountPerPerson: (data['amount_per_person'] as num).toDouble(),
      status: GroupBookingStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => GroupBookingStatus.pending,
      ),
      confirmationDeadline: data['confirmation_deadline'] != null
          ? DateTime.parse(data['confirmation_deadline'] as String)
          : null,
      specialRequests: data['special_requests'] as String?,
      createdAt: DateTime.parse(data['created_at'] as String),
      updatedAt: data['updated_at'] != null
          ? DateTime.parse(data['updated_at'] as String)
          : null,
    );
  }
}

@freezed
class GroupMember with _$GroupMember {
  const factory GroupMember({
    required String id,
    required String groupBookingId,
    required String userId,
    required String userName,
    String? userEmail,
    String? userPhone,
    required double amountOwed,
    double? amountPaid,
    @Default(MemberStatus.invited) MemberStatus status,
    DateTime? invitedAt,
    DateTime? respondedAt,
    DateTime? paidAt,
    String? paymentIntentId,
  }) = _GroupMember;

  factory GroupMember.fromJson(Map<String, dynamic> json) =>
      _$GroupMemberFromJson(json);

  factory GroupMember.fromSupabase(Map<String, dynamic> data) {
    return GroupMember(
      id: data['id'] as String,
      groupBookingId: data['group_booking_id'] as String,
      userId: data['user_id'] as String,
      userName: data['user_name'] as String,
      userEmail: data['user_email'] as String?,
      userPhone: data['user_phone'] as String?,
      amountOwed: (data['amount_owed'] as num).toDouble(),
      amountPaid: (data['amount_paid'] as num?)?.toDouble(),
      status: MemberStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => MemberStatus.invited,
      ),
      invitedAt: data['invited_at'] != null
          ? DateTime.parse(data['invited_at'] as String)
          : null,
      respondedAt: data['responded_at'] != null
          ? DateTime.parse(data['responded_at'] as String)
          : null,
      paidAt: data['paid_at'] != null
          ? DateTime.parse(data['paid_at'] as String)
          : null,
      paymentIntentId: data['payment_intent_id'] as String?,
    );
  }
}

@freezed
class GroupInvite with _$GroupInvite {
  const factory GroupInvite({
    required String id,
    required String groupBookingId,
    required String invitedByUserId,
    required String invitedByName,
    String? recipientUserId,
    String? recipientEmail,
    String? recipientPhone,
    required String inviteToken,
    @Default(false) bool isAccepted,
    DateTime? expiresAt,
    DateTime? acceptedAt,
    required DateTime createdAt,
  }) = _GroupInvite;

  factory GroupInvite.fromJson(Map<String, dynamic> json) =>
      _$GroupInviteFromJson(json);

  factory GroupInvite.fromSupabase(Map<String, dynamic> data) {
    return GroupInvite(
      id: data['id'] as String,
      groupBookingId: data['group_booking_id'] as String,
      invitedByUserId: data['invited_by_user_id'] as String,
      invitedByName: data['invited_by_name'] as String,
      recipientUserId: data['recipient_user_id'] as String?,
      recipientEmail: data['recipient_email'] as String?,
      recipientPhone: data['recipient_phone'] as String?,
      inviteToken: data['invite_token'] as String,
      isAccepted: data['is_accepted'] as bool? ?? false,
      expiresAt: data['expires_at'] != null
          ? DateTime.parse(data['expires_at'] as String)
          : null,
      acceptedAt: data['accepted_at'] != null
          ? DateTime.parse(data['accepted_at'] as String)
          : null,
      createdAt: DateTime.parse(data['created_at'] as String),
    );
  }
}
