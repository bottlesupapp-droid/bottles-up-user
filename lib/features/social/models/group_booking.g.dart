// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GroupBookingImpl _$$GroupBookingImplFromJson(Map<String, dynamic> json) =>
    _$GroupBookingImpl(
      id: json['id'] as String,
      organizerId: json['organizerId'] as String,
      organizerName: json['organizerName'] as String,
      organizerAvatar: json['organizerAvatar'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      status: $enumDecode(_$GroupBookingStatusEnumMap, json['status']),
      venueId: json['venueId'] as String?,
      venueName: json['venueName'] as String?,
      eventId: json['eventId'] as String?,
      eventName: json['eventName'] as String?,
      proposedDate: json['proposedDate'] == null
          ? null
          : DateTime.parse(json['proposedDate'] as String),
      members: (json['members'] as List<dynamic>?)
              ?.map((e) => GroupMember.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      venueProposals: (json['venueProposals'] as List<dynamic>?)
              ?.map((e) => VenueProposal.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      votingDeadline: json['votingDeadline'] == null
          ? null
          : DateTime.parse(json['votingDeadline'] as String),
      bookingDetails: json['bookingDetails'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      confirmedAt: json['confirmedAt'] == null
          ? null
          : DateTime.parse(json['confirmedAt'] as String),
    );

Map<String, dynamic> _$$GroupBookingImplToJson(_$GroupBookingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organizerId': instance.organizerId,
      'organizerName': instance.organizerName,
      'organizerAvatar': instance.organizerAvatar,
      'name': instance.name,
      'description': instance.description,
      'status': _$GroupBookingStatusEnumMap[instance.status]!,
      'venueId': instance.venueId,
      'venueName': instance.venueName,
      'eventId': instance.eventId,
      'eventName': instance.eventName,
      'proposedDate': instance.proposedDate?.toIso8601String(),
      'members': instance.members,
      'venueProposals': instance.venueProposals,
      'votingDeadline': instance.votingDeadline?.toIso8601String(),
      'bookingDetails': instance.bookingDetails,
      'createdAt': instance.createdAt.toIso8601String(),
      'confirmedAt': instance.confirmedAt?.toIso8601String(),
    };

const _$GroupBookingStatusEnumMap = {
  GroupBookingStatus.planning: 'planning',
  GroupBookingStatus.voting: 'voting',
  GroupBookingStatus.confirmed: 'confirmed',
  GroupBookingStatus.cancelled: 'cancelled',
  GroupBookingStatus.completed: 'completed',
};

_$GroupMemberImpl _$$GroupMemberImplFromJson(Map<String, dynamic> json) =>
    _$GroupMemberImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userAvatar: json['userAvatar'] as String?,
      userEmail: json['userEmail'] as String?,
      response:
          $enumDecodeNullable(_$InvitationResponseEnumMap, json['response']) ??
              InvitationResponse.pending,
      invitedAt: DateTime.parse(json['invitedAt'] as String),
      respondedAt: json['respondedAt'] == null
          ? null
          : DateTime.parse(json['respondedAt'] as String),
      isOrganizer: json['isOrganizer'] as bool? ?? false,
      preferences: json['preferences'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$GroupMemberImplToJson(_$GroupMemberImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userName': instance.userName,
      'userAvatar': instance.userAvatar,
      'userEmail': instance.userEmail,
      'response': _$InvitationResponseEnumMap[instance.response]!,
      'invitedAt': instance.invitedAt.toIso8601String(),
      'respondedAt': instance.respondedAt?.toIso8601String(),
      'isOrganizer': instance.isOrganizer,
      'preferences': instance.preferences,
    };

const _$InvitationResponseEnumMap = {
  InvitationResponse.pending: 'pending',
  InvitationResponse.accepted: 'accepted',
  InvitationResponse.declined: 'declined',
  InvitationResponse.maybe: 'maybe',
};

_$VenueProposalImpl _$$VenueProposalImplFromJson(Map<String, dynamic> json) =>
    _$VenueProposalImpl(
      id: json['id'] as String,
      venueId: json['venueId'] as String,
      venueName: json['venueName'] as String,
      venueImage: json['venueImage'] as String?,
      proposedBy: json['proposedBy'] as String,
      proposerName: json['proposerName'] as String,
      proposerAvatar: json['proposerAvatar'] as String?,
      proposedDate: json['proposedDate'] == null
          ? null
          : DateTime.parse(json['proposedDate'] as String),
      notes: json['notes'] as String?,
      votes: (json['votes'] as List<dynamic>?)
              ?.map((e) => VenueVote.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      upvotes: (json['upvotes'] as num?)?.toInt() ?? 0,
      downvotes: (json['downvotes'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$VenueProposalImplToJson(_$VenueProposalImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'venueId': instance.venueId,
      'venueName': instance.venueName,
      'venueImage': instance.venueImage,
      'proposedBy': instance.proposedBy,
      'proposerName': instance.proposerName,
      'proposerAvatar': instance.proposerAvatar,
      'proposedDate': instance.proposedDate?.toIso8601String(),
      'notes': instance.notes,
      'votes': instance.votes,
      'upvotes': instance.upvotes,
      'downvotes': instance.downvotes,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_$VenueVoteImpl _$$VenueVoteImplFromJson(Map<String, dynamic> json) =>
    _$VenueVoteImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userAvatar: json['userAvatar'] as String?,
      isUpvote: json['isUpvote'] as bool,
      comment: json['comment'] as String?,
      votedAt: DateTime.parse(json['votedAt'] as String),
    );

Map<String, dynamic> _$$VenueVoteImplToJson(_$VenueVoteImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userName': instance.userName,
      'userAvatar': instance.userAvatar,
      'isUpvote': instance.isUpvote,
      'comment': instance.comment,
      'votedAt': instance.votedAt.toIso8601String(),
    };

_$GroupMessageImpl _$$GroupMessageImplFromJson(Map<String, dynamic> json) =>
    _$GroupMessageImpl(
      id: json['id'] as String,
      groupBookingId: json['groupBookingId'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      senderAvatar: json['senderAvatar'] as String?,
      message: json['message'] as String,
      messageType: json['messageType'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      sentAt: DateTime.parse(json['sentAt'] as String),
    );

Map<String, dynamic> _$$GroupMessageImplToJson(_$GroupMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'groupBookingId': instance.groupBookingId,
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'senderAvatar': instance.senderAvatar,
      'message': instance.message,
      'messageType': instance.messageType,
      'metadata': instance.metadata,
      'sentAt': instance.sentAt.toIso8601String(),
    };
