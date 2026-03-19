import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/announcement.dart';

class AnnouncementService {
  static final AnnouncementService _instance = AnnouncementService._internal();
  factory AnnouncementService() => _instance;
  AnnouncementService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  /// Create an announcement (host only)
  Future<Announcement> createAnnouncement({
    required String eventId,
    required String title,
    required String message,
    bool isPinned = false,
    int priority = 0,
    List<String>? images,
    String? link,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final data = {
      'event_id': eventId,
      'host_id': userId,
      'title': title,
      'message': message,
      'is_pinned': isPinned,
      'priority': priority,
      'images': images,
      'link': link,
    };

    final response = await _supabase
        .from('announcements')
        .insert(data)
        .select()
        .single();

    return Announcement.fromSupabase(response);
  }

  /// Get all announcements for an event
  Future<List<Announcement>> getEventAnnouncements(String eventId) async {
    final response = await _supabase
        .from('announcements')
        .select('''
          *,
          users!host_id(full_name, avatar_url),
          events!event_id(name)
        ''')
        .eq('event_id', eventId)
        .order('is_pinned', ascending: false)
        .order('priority', ascending: false)
        .order('created_at', ascending: false);

    return (response as List).map((item) {
      final user = item['users'] as Map<String, dynamic>?;
      final event = item['events'] as Map<String, dynamic>?;
      return Announcement.fromSupabase({
        ...item,
        'host_name': user?['full_name'],
        'host_avatar': user?['avatar_url'],
        'event_name': event?['name'],
      });
    }).toList();
  }

  /// Update announcement
  Future<void> updateAnnouncement({
    required String announcementId,
    String? title,
    String? message,
    bool? isPinned,
    int? priority,
  }) async {
    final updates = <String, dynamic>{};
    if (title != null) updates['title'] = title;
    if (message != null) updates['message'] = message;
    if (isPinned != null) updates['is_pinned'] = isPinned;
    if (priority != null) updates['priority'] = priority;

    await _supabase
        .from('announcements')
        .update(updates)
        .eq('id', announcementId);
  }

  /// Delete announcement
  Future<void> deleteAnnouncement(String announcementId) async {
    await _supabase
        .from('announcements')
        .delete()
        .eq('id', announcementId);
  }

  /// Pin/unpin announcement
  Future<void> togglePin(String announcementId, bool isPinned) async {
    await _supabase
        .from('announcements')
        .update({'is_pinned': isPinned})
        .eq('id', announcementId);
  }
}
