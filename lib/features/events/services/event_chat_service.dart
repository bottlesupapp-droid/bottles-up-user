import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/event_chat.dart';

class EventChatService {
  static final EventChatService _instance = EventChatService._internal();
  factory EventChatService() => _instance;
  EventChatService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  /// Send message to event chat
  Future<EventChatMessage> sendMessage({
    required String eventId,
    required String message,
    String? replyToId,
    List<String>? images,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final data = {
      'event_id': eventId,
      'user_id': userId,
      'message': message,
      'reply_to_id': replyToId,
      'images': images,
    };

    final response = await _supabase
        .from('event_chat_messages')
        .insert(data)
        .select()
        .single();

    return EventChatMessage.fromSupabase(response);
  }

  /// Get event chat messages
  Future<List<EventChatMessage>> getEventMessages(String eventId, {int limit = 50, int offset = 0}) async {
    final response = await _supabase
        .from('event_chat_messages')
        .select('''
          *,
          users!user_id(full_name, avatar_url),
          reply_to:event_chat_messages!reply_to_id(message, users!user_id(full_name))
        ''')
        .eq('event_id', eventId)
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    return (response as List).map((item) {
      final user = item['users'] as Map<String, dynamic>?;
      final replyTo = item['reply_to'] as Map<String, dynamic>?;
      final replyToUser = replyTo?['users'] as Map<String, dynamic>?;

      return EventChatMessage.fromSupabase({
        ...item,
        'user_name': user?['full_name'],
        'user_avatar': user?['avatar_url'],
        'reply_to_message': replyTo?['message'],
        'reply_to_user_name': replyToUser?['full_name'],
      });
    }).toList();
  }

  /// Pin/unpin message (host only)
  Future<void> togglePinMessage(String messageId, bool isPinned) async {
    await _supabase
        .from('event_chat_messages')
        .update({'is_pinned': isPinned})
        .eq('id', messageId);
  }

  /// Get pinned messages for event
  Future<List<EventChatMessage>> getPinnedMessages(String eventId) async {
    final response = await _supabase
        .from('event_chat_messages')
        .select('''
          *,
          users!user_id(full_name, avatar_url)
        ''')
        .eq('event_id', eventId)
        .eq('is_pinned', true)
        .order('created_at', ascending: false);

    return (response as List).map((item) {
      final user = item['users'] as Map<String, dynamic>?;
      return EventChatMessage.fromSupabase({
        ...item,
        'user_name': user?['full_name'],
        'user_avatar': user?['avatar_url'],
      });
    }).toList();
  }

  /// Delete message
  Future<void> deleteMessage(String messageId) async {
    await _supabase
        .from('event_chat_messages')
        .delete()
        .eq('id', messageId);
  }

  /// Subscribe to event chat updates
  RealtimeChannel subscribeToEventChat(
    String eventId,
    void Function(EventChatMessage) onNewMessage,
  ) {
    return _supabase
        .channel('event_chat_$eventId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'event_chat_messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'event_id',
            value: eventId,
          ),
          callback: (payload) {
            final message = EventChatMessage.fromSupabase(payload.newRecord);
            onNewMessage(message);
          },
        )
        .subscribe();
  }
}
