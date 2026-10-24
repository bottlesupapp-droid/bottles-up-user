import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_booking.freezed.dart';
part 'group_booking.g.dart';

enum GroupBookingStatus {
  planning,
  voting,
  confirmed,
  cancelled,
  completed,
}

enum InvitationResponse {
  pending,
  accepted,
  declined,
  maybe,
}

@freezed
class GroupBooking with _$GroupBooking {
  const factory GroupBooking({
    required String id,
    required String organizerId,
    required String organizerName,
    String? organizerAvatar,
    required String name,
    String? description,
    required GroupBookingStatus status,
    String? venueId,
    String? venueName,
    String? eventId,
    String? eventName,
    DateTime? proposedDate,
    @Default([]) List<GroupMember> members,
    @Default([]) List<VenueProposal> venueProposals,
    DateTime? votingDeadline,
    Map<String, dynamic>? bookingDetails,
    required DateTime createdAt,
    DateTime? confirmedAt,
  }) = _GroupBooking;

  factory GroupBooking.fromJson(Map<String, dynamic> json) =>
      _$GroupBookingFromJson(json);

  factory GroupBooking.fromSupabase(Map<String, dynamic> data) {
    return GroupBooking(
      id: data['id'] as String,
      organizerId: data['organizer_id'] as String,
      organizerName: data['organizer_name'] as String,
      organizerAvatar: data['organizer_avatar'] as String?,
      name: data['name'] as String,
      description: data['description'] as String?,
      status: GroupBookingStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => GroupBookingStatus.planning,
      ),
      venueId: data['venue_id'] as String?,
      venueName: data['venue_name'] as String?,
      eventId: data['event_id'] as String?,
      eventName: data['event_name'] as String?,
      proposedDate: data['proposed_date'] != null
          ? DateTime.parse(data['proposed_date'] as String)
          : null,
      members: data['members'] != null
          ? (data['members'] as List)
              .map((m) => GroupMember.fromJson(m as Map<String, dynamic>))
              .toList()
          : [],
      venueProposals: data['venue_proposals'] != null
          ? (data['venue_proposals'] as List)
              .map((v) => VenueProposal.fromJson(v as Map<String, dynamic>))
              .toList()
          : [],
      votingDeadline: data['voting_deadline'] != null
          ? DateTime.parse(data['voting_deadline'] as String)
          : null,
      bookingDetails: data['booking_details'] != null
          ? Map<String, dynamic>.from(data['booking_details'] as Map)
          : null,
      createdAt: DateTime.parse(data['created_at'] as String),
      confirmedAt: data['confirmed_at'] != null
          ? DateTime.parse(data['confirmed_at'] as String)
          : null,
    );
  }
}

@freezed
class GroupMember with _$GroupMember {
  const factory GroupMember({
    required String id,
    required String userId,
    required String userName,
    String? userAvatar,
    String? userEmail,
    @Default(InvitationResponse.pending) InvitationResponse response,
    required DateTime invitedAt,
    DateTime? respondedAt,
    @Default(false) bool isOrganizer,
    Map<String, dynamic>? preferences,
  }) = _GroupMember;

  factory GroupMember.fromJson(Map<String, dynamic> json) =>
      _$GroupMemberFromJson(json);

  factory GroupMember.fromSupabase(Map<String, dynamic> data) {
    return GroupMember(
      id: data['id'] as String,
      userId: data['user_id'] as String,
      userName: data['user_name'] as String,
      userAvatar: data['user_avatar'] as String?,
      userEmail: data['user_email'] as String?,
      response: InvitationResponse.values.firstWhere(
        (e) => e.name == data['response'],
        orElse: () => InvitationResponse.pending,
      ),
      invitedAt: DateTime.parse(data['invited_at'] as String),
      respondedAt: data['responded_at'] != null
          ? DateTime.parse(data['responded_at'] as String)
          : null,
      isOrganizer: data['is_organizer'] as bool? ?? false,
      preferences: data['preferences'] != null
          ? Map<String, dynamic>.from(data['preferences'] as Map)
          : null,
    );
  }
}

@freezed
class VenueProposal with _$VenueProposal {
  const factory VenueProposal({
    required String id,
    required String venueId,
    required String venueName,
    String? venueImage,
    required String proposedBy,
    required String proposerName,
    String? proposerAvatar,
    DateTime? proposedDate,
    String? notes,
    @Default([]) List<VenueVote> votes,
    @Default(0) int upvotes,
    @Default(0) int downvotes,
    required DateTime createdAt,
  }) = _VenueProposal;

  factory VenueProposal.fromJson(Map<String, dynamic> json) =>
      _$VenueProposalFromJson(json);

  factory VenueProposal.fromSupabase(Map<String, dynamic> data) {
    return VenueProposal(
      id: data['id'] as String,
      venueId: data['venue_id'] as String,
      venueName: data['venue_name'] as String,
      venueImage: data['venue_image'] as String?,
      proposedBy: data['proposed_by'] as String,
      proposerName: data['proposer_name'] as String,
      proposerAvatar: data['proposer_avatar'] as String?,
      proposedDate: data['proposed_date'] != null
          ? DateTime.parse(data['proposed_date'] as String)
          : null,
      notes: data['notes'] as String?,
      votes: data['votes'] != null
          ? (data['votes'] as List)
              .map((v) => VenueVote.fromJson(v as Map<String, dynamic>))
              .toList()
          : [],
      upvotes: data['upvotes'] as int? ?? 0,
      downvotes: data['downvotes'] as int? ?? 0,
      createdAt: DateTime.parse(data['created_at'] as String),
    );
  }
}

@freezed
class VenueVote with _$VenueVote {
  const factory VenueVote({
    required String id,
    required String userId,
    required String userName,
    String? userAvatar,
    required bool isUpvote,
    String? comment,
    required DateTime votedAt,
  }) = _VenueVote;

  factory VenueVote.fromJson(Map<String, dynamic> json) =>
      _$VenueVoteFromJson(json);

  factory VenueVote.fromSupabase(Map<String, dynamic> data) {
    return VenueVote(
      id: data['id'] as String,
      userId: data['user_id'] as String,
      userName: data['user_name'] as String,
      userAvatar: data['user_avatar'] as String?,
      isUpvote: data['is_upvote'] as bool,
      comment: data['comment'] as String?,
      votedAt: DateTime.parse(data['voted_at'] as String),
    );
  }
}

@freezed
class GroupMessage with _$GroupMessage {
  const factory GroupMessage({
    required String id,
    required String groupBookingId,
    required String senderId,
    required String senderName,
    String? senderAvatar,
    required String message,
    String? messageType,
    Map<String, dynamic>? metadata,
    required DateTime sentAt,
  }) = _GroupMessage;

  factory GroupMessage.fromJson(Map<String, dynamic> json) =>
      _$GroupMessageFromJson(json);

  factory GroupMessage.fromSupabase(Map<String, dynamic> data) {
    return GroupMessage(
      id: data['id'] as String,
      groupBookingId: data['group_booking_id'] as String,
      senderId: data['sender_id'] as String,
      senderName: data['sender_name'] as String,
      senderAvatar: data['sender_avatar'] as String?,
      message: data['message'] as String,
      messageType: data['message_type'] as String?,
      metadata: data['metadata'] != null
          ? Map<String, dynamic>.from(data['metadata'] as Map)
          : null,
      sentAt: DateTime.parse(data['sent_at'] as String),
    );
  }
}
