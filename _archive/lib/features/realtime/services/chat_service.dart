import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/realtime_models.dart';

class ChatService {
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;
  final Map<String, RealtimeChannel> _chatChannels = {};

  // Send message
  Future<ChatMessage> sendMessage({
    required String conversationId,
    required String content,
    String messageType = 'text',
    List<String>? attachments,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase.from('chat_messages').insert({
        'conversation_id': conversationId,
        'sender_id': currentUser.id,
        'content': content,
        'message_type': messageType,
        'attachments': attachments ?? [],
        'metadata': metadata,
      }).select().single();

      return ChatMessage.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  // Get messages
  Future<List<ChatMessage>> getMessages({
    required String conversationId,
    int limit = 50,
    String? beforeMessageId,
  }) async {
    try {
      var query = _supabase
          .from('chat_messages')
          .select()
          .eq('conversation_id', conversationId)
          .order('sent_at', ascending: false)
          .limit(limit);

      if (beforeMessageId != null) {
        final beforeMessage = await _supabase
            .from('chat_messages')
            .select('sent_at')
            .eq('id', beforeMessageId)
            .single();

        query = query.lt('sent_at', beforeMessage['sent_at']);
      }

      final response = await query;

      return (response as List)
          .map((item) => ChatMessage.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Mark message as read
  Future<void> markAsRead(String messageId) async {
    try {
      await _supabase.from('chat_messages').update({
        'is_read': true,
        'read_at': DateTime.now().toIso8601String(),
      }).eq('id', messageId);
    } catch (e) {
      // Non-critical error
    }
  }

  // Mark all conversation messages as read
  Future<void> markConversationAsRead(String conversationId) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return;

      await _supabase.from('chat_messages').update({
        'is_read': true,
        'read_at': DateTime.now().toIso8601String(),
      }).eq('conversation_id', conversationId).neq('sender_id', currentUser.id);
    } catch (e) {
      // Non-critical error
    }
  }

  // Edit message
  Future<ChatMessage> editMessage({
    required String messageId,
    required String newContent,
  }) async {
    try {
      final response = await _supabase.from('chat_messages').update({
        'content': newContent,
        'is_edited': true,
        'edited_at': DateTime.now().toIso8601String(),
      }).eq('id', messageId).select().single();

      return ChatMessage.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to edit message: $e');
    }
  }

  // Delete message
  Future<void> deleteMessage(String messageId) async {
    try {
      await _supabase.from('chat_messages').delete().eq('id', messageId);
    } catch (e) {
      throw Exception('Failed to delete message: $e');
    }
  }

  // Subscribe to conversation
  RealtimeChannel subscribeToConversation({
    required String conversationId,
    required Function(ChatMessage) onNewMessage,
    Function(ChatMessage)? onMessageUpdated,
    Function(String messageId)? onMessageDeleted,
  }) {
    // Unsubscribe existing channel if present
    if (_chatChannels.containsKey(conversationId)) {
      _chatChannels[conversationId]!.unsubscribe();
    }

    final channel = _supabase.channel('chat_$conversationId');

    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'chat_messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'conversation_id',
            value: conversationId,
          ),
          callback: (payload) {
            final message = ChatMessage.fromSupabase(payload.newRecord);
            onNewMessage(message);
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'chat_messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'conversation_id',
            value: conversationId,
          ),
          callback: (payload) {
            if (onMessageUpdated != null) {
              final message = ChatMessage.fromSupabase(payload.newRecord);
              onMessageUpdated(message);
            }
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.delete,
          schema: 'public',
          table: 'chat_messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'conversation_id',
            value: conversationId,
          ),
          callback: (payload) {
            if (onMessageDeleted != null) {
              final messageId = payload.oldRecord['id'] as String;
              onMessageDeleted(messageId);
            }
          },
        )
        .subscribe();

    _chatChannels[conversationId] = channel;
    return channel;
  }

  // Unsubscribe from conversation
  void unsubscribeFromConversation(String conversationId) {
    if (_chatChannels.containsKey(conversationId)) {
      _chatChannels[conversationId]!.unsubscribe();
      _chatChannels.remove(conversationId);
    }
  }

  // Unsubscribe from all conversations
  void unsubscribeAll() {
    for (final channel in _chatChannels.values) {
      channel.unsubscribe();
    }
    _chatChannels.clear();
  }

  // Get unread message count
  Future<int> getUnreadCount(String conversationId) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return 0;

      final response = await _supabase.rpc('get_unread_message_count', params: {
        'conversation_id_param': conversationId,
        'user_id_param': currentUser.id,
      });

      return response as int? ?? 0;
    } catch (e) {
      return 0;
    }
  }

  // Get all conversations with unread counts
  Future<List<Map<String, dynamic>>> getConversations() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return [];

      final response = await _supabase.rpc('get_user_conversations', params: {
        'user_id_param': currentUser.id,
      });

      return List<Map<String, dynamic>>.from(response as List? ?? []);
    } catch (e) {
      return [];
    }
  }
}

class PresenceService {
  static final PresenceService _instance = PresenceService._internal();
  factory PresenceService() => _instance;
  PresenceService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;
  RealtimeChannel? _presenceChannel;

  // Update user presence
  Future<void> updatePresence({
    required bool isOnline,
    String? currentActivity,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return;

      await _supabase.from('user_presence').upsert({
        'user_id': currentUser.id,
        'is_online': isOnline,
        'last_seen': DateTime.now().toIso8601String(),
        'current_activity': currentActivity,
        'metadata': metadata,
      });
    } catch (e) {
      // Non-critical error
    }
  }

  // Get user presence
  Future<UserPresence?> getUserPresence(String userId) async {
    try {
      final response = await _supabase
          .from('user_presence')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) return null;

      return UserPresence.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  // Subscribe to user presence
  RealtimeChannel subscribeToUserPresence({
    required String userId,
    required Function(UserPresence) onPresenceChanged,
  }) {
    final channel = _supabase.channel('presence_$userId');

    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'user_presence',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) {
            final presence = UserPresence.fromSupabase(payload.newRecord);
            onPresenceChanged(presence);
          },
        )
        .subscribe();

    return channel;
  }

  // Subscribe to multiple users presence
  RealtimeChannel subscribeToMultiplePresences({
    required List<String> userIds,
    required Function(String userId, UserPresence) onPresenceChanged,
  }) {
    _presenceChannel?.unsubscribe();

    final channel = _supabase.channel('presences_multiple');

    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'user_presence',
          callback: (payload) {
            final userId = payload.newRecord['user_id'] as String;
            if (userIds.contains(userId)) {
              final presence = UserPresence.fromSupabase(payload.newRecord);
              onPresenceChanged(userId, presence);
            }
          },
        )
        .subscribe();

    _presenceChannel = channel;
    return channel;
  }

  // Send typing indicator
  Future<void> sendTypingIndicator({
    required String conversationId,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return;

      // Use Supabase Broadcast for ephemeral typing indicators
      final channel = _supabase.channel('typing_$conversationId');

      await channel.sendBroadcastMessage(
        event: 'typing',
        payload: {
          'user_id': currentUser.id,
          'conversation_id': conversationId,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      // Non-critical error
    }
  }

  // Subscribe to typing indicators
  RealtimeChannel subscribeToTypingIndicators({
    required String conversationId,
    required Function(TypingIndicator) onTyping,
  }) {
    final channel = _supabase.channel('typing_$conversationId');

    channel
        .onBroadcast(
          event: 'typing',
          callback: (payload) {
            final currentUser = _supabase.auth.currentUser;
            final senderId = payload['user_id'] as String;

            // Don't show own typing indicator
            if (currentUser != null && senderId != currentUser.id) {
              final indicator = TypingIndicator(
                conversationId: conversationId,
                userId: senderId,
                userName: payload['user_name'] as String? ?? 'User',
                startedAt: DateTime.parse(payload['timestamp'] as String),
              );
              onTyping(indicator);
            }
          },
        )
        .subscribe();

    return channel;
  }

  // Set user online
  Future<void> goOnline() async {
    await updatePresence(isOnline: true);
  }

  // Set user offline
  Future<void> goOffline() async {
    await updatePresence(isOnline: false);
  }

  void unsubscribe() {
    _presenceChannel?.unsubscribe();
    _presenceChannel = null;
  }
}
