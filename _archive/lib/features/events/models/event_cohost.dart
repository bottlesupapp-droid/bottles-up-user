import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_cohost.freezed.dart';
part 'event_cohost.g.dart';

enum CohostStatus {
  pending,
  accepted,
  declined,
  removed,
}

enum CohostPermission {
  editEvent,
  manageGuestList,
  sendAnnouncements,
  moderateChat,
  managePoll,
  inviteCohost,
  viewAnalytics,
}

@freezed
class EventCohost with _$EventCohost {
  const factory EventCohost({
    required String id,
    required String eventId,
    required String userId,
    required String userName,
    String? userAvatar,
    required String invitedBy,
    required CohostStatus status,
    required List<CohostPermission> permissions,
    required DateTime invitedAt,
    DateTime? respondedAt,
    DateTime? createdAt,
    String? notes,
    @Default(false) bool isPrimaryHost,
  }) = _EventCohost;

  factory EventCohost.fromJson(Map<String, dynamic> json) =>
      _$EventCohostFromJson(json);

  factory EventCohost.fromSupabase(Map<String, dynamic> data) {
    // Parse permissions from JSON array
    final permissionsData = data['permissions'] as List<dynamic>? ?? [];
    final permissions = permissionsData
        .map((p) => CohostPermission.values.firstWhere(
              (e) => e.name == p.toString(),
              orElse: () => CohostPermission.viewAnalytics,
            ))
        .toList();

    return EventCohost(
      id: data['id'] as String,
      eventId: data['event_id'] as String,
      userId: data['user_id'] as String,
      userName: data['user_name'] as String? ?? 'Unknown',
      userAvatar: data['user_avatar'] as String?,
      invitedBy: data['invited_by'] as String,
      status: CohostStatus.values.firstWhere(
        (s) => s.name == data['status'],
        orElse: () => CohostStatus.pending,
      ),
      permissions: permissions,
      invitedAt: DateTime.parse(data['invited_at'] as String),
      respondedAt: data['responded_at'] != null
          ? DateTime.parse(data['responded_at'] as String)
          : null,
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at'] as String)
          : null,
      notes: data['notes'] as String?,
      isPrimaryHost: data['is_primary_host'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toSupabase() {
    return {
      'event_id': eventId,
      'user_id': userId,
      'invited_by': invitedBy,
      'status': status.name,
      'permissions': permissions.map((p) => p.name).toList(),
      'notes': notes,
      'is_primary_host': isPrimaryHost,
    };
  }
}

@freezed
class CohostInvitation with _$CohostInvitation {
  const factory CohostInvitation({
    required String eventId,
    required String eventName,
    required String userId,
    required String userEmail,
    String? userName,
    required List<CohostPermission> permissions,
    String? message,
  }) = _CohostInvitation;

  factory CohostInvitation.fromJson(Map<String, dynamic> json) =>
      _$CohostInvitationFromJson(json);
}

// Permission presets for quick setup
class CohostPermissionPresets {
  static List<CohostPermission> get fullAccess => [
        CohostPermission.editEvent,
        CohostPermission.manageGuestList,
        CohostPermission.sendAnnouncements,
        CohostPermission.moderateChat,
        CohostPermission.managePoll,
        CohostPermission.inviteCohost,
        CohostPermission.viewAnalytics,
      ];

  static List<CohostPermission> get moderator => [
        CohostPermission.manageGuestList,
        CohostPermission.moderateChat,
        CohostPermission.managePoll,
        CohostPermission.viewAnalytics,
      ];

  static List<CohostPermission> get limited => [
        CohostPermission.viewAnalytics,
        CohostPermission.moderateChat,
      ];
}
