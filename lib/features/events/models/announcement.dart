import 'package:freezed_annotation/freezed_annotation.dart';

part 'announcement.freezed.dart';
part 'announcement.g.dart';

@freezed
class Announcement with _$Announcement {
  const factory Announcement({
    required String id,
    required String eventId,
    required String hostId,
    required String title,
    required String message,
    @Default(false) bool isPinned,
    @Default(0) int priority,
    List<String>? images,
    String? link,
    DateTime? createdAt,
    DateTime? updatedAt,

    // Joined data
    String? hostName,
    String? hostAvatar,
    String? eventName,
  }) = _Announcement;

  factory Announcement.fromJson(Map<String, dynamic> json) => _$AnnouncementFromJson(json);

  factory Announcement.fromSupabase(Map<String, dynamic> data) {
    return Announcement(
      id: data['id'] as String,
      eventId: data['event_id'] as String,
      hostId: data['host_id'] as String,
      title: data['title'] as String,
      message: data['message'] as String,
      isPinned: data['is_pinned'] as bool? ?? false,
      priority: data['priority'] as int? ?? 0,
      images: data['images'] != null ? List<String>.from(data['images']) : null,
      link: data['link'] as String?,
      createdAt: data['created_at'] != null ? DateTime.parse(data['created_at'] as String) : null,
      updatedAt: data['updated_at'] != null ? DateTime.parse(data['updated_at'] as String) : null,
      hostName: data['host_name'] as String?,
      hostAvatar: data['host_avatar'] as String?,
      eventName: data['event_name'] as String?,
    );
  }
}
