import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/announcement.dart';
import '../services/announcement_service.dart';

part 'announcement_provider.g.dart';

// Event Announcements Provider
@riverpod
class EventAnnouncements extends _$EventAnnouncements {
  @override
  Future<List<Announcement>> build(String eventId) async {
    return AnnouncementService().getEventAnnouncements(eventId);
  }

  Future<void> createAnnouncement({
    required String eventId,
    required String title,
    required String message,
    bool isPinned = false,
    int priority = 0,
    List<String>? images,
    String? link,
  }) async {
    await AnnouncementService().createAnnouncement(
      eventId: eventId,
      title: title,
      message: message,
      isPinned: isPinned,
      priority: priority,
      images: images,
      link: link,
    );
    ref.invalidateSelf();
  }

  Future<void> updateAnnouncement({
    required String announcementId,
    String? title,
    String? message,
    bool? isPinned,
    int? priority,
  }) async {
    await AnnouncementService().updateAnnouncement(
      announcementId: announcementId,
      title: title,
      message: message,
      isPinned: isPinned,
      priority: priority,
    );
    ref.invalidateSelf();
  }

  Future<void> deleteAnnouncement(String announcementId) async {
    await AnnouncementService().deleteAnnouncement(announcementId);
    ref.invalidateSelf();
  }

  Future<void> togglePin(String announcementId, bool isPinned) async {
    await AnnouncementService().togglePin(announcementId, isPinned);
    ref.invalidateSelf();
  }
}
