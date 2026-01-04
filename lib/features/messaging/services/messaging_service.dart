import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/conversation.dart';
import '../models/message.dart';

class MessagingService {
  static final MessagingService _instance = MessagingService._internal();
  factory MessagingService() => _instance;
  MessagingService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  /// Get current user ID
  String? get currentUserId => _supabase.auth.currentUser?.id;

  /// Get all conversations for the current user
  Future<List<Conversation>> getConversations() async {
    try {
      final userId = currentUserId;
      if (userId == null) throw Exception('User not authenticated');

      // First, get conversation IDs for the current user
      final participantResponse = await _supabase
          .from('conversation_participants')
          .select('conversation_id')
          .eq('user_id', userId);

      if (participantResponse.isEmpty) {
        return [];
      }

      final conversationIds = (participantResponse as List)
          .map((e) => e['conversation_id'] as String)
          .toList();

      // Then fetch the conversations with messages
      final response = await _supabase
          .from('conversations')
          .select('''
            *,
            messages(id, content, sender_id, created_at)
          ''')
          .inFilter('id', conversationIds)
          .order('last_message_at', ascending: false);

      return (response as List).map((data) {
        // Get last message if exists
        final messages = data['messages'] as List?;
        String? lastMessageContent;
        String? lastMessageSenderId;

        if (messages != null && messages.isNotEmpty) {
          final lastMsg = messages.last;
          lastMessageContent = lastMsg['content'];
          lastMessageSenderId = lastMsg['sender_id'];
        }

        return Conversation.fromSupabase({
          ...data,
          'last_message_content': lastMessageContent,
          'last_message_sender_id': lastMessageSenderId,
        });
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch conversations: $e');
    }
  }

  /// Get conversation by ID with participants
  Future<Conversation?> getConversation(String conversationId) async {
    try {
      final response = await _supabase
          .from('conversations')
          .select('*')
          .eq('id', conversationId)
          .single();

      return Conversation.fromSupabase(response);
    } catch (e) {
      throw Exception('Failed to fetch conversation: $e');
    }
  }

  /// Create a direct conversation
  Future<Conversation> createDirectConversation(String otherUserId) async {
    try {
      final userId = currentUserId;
      if (userId == null) throw Exception('User not authenticated');

      // Check if conversation already exists between these two users
      // Get all direct conversations where current user is a participant
      final myConversations = await _supabase
          .from('conversation_participants')
          .select('conversation_id')
          .eq('user_id', userId);

      if (myConversations.isNotEmpty) {
        final conversationIds = (myConversations as List)
            .map((e) => e['conversation_id'] as String)
            .toList();

        // Check if any of these conversations also has the other user
        final sharedConversation = await _supabase
            .from('conversation_participants')
            .select('conversation_id, conversations!inner(id, type)')
            .eq('user_id', otherUserId)
            .inFilter('conversation_id', conversationIds);

        // Find a direct conversation (not group) between these users
        for (final item in sharedConversation as List) {
          final conversation = item['conversations'];
          if (conversation['type'] == 'direct') {
            // Conversation already exists, return it
            final existing = await getConversation(conversation['id']);
            if (existing != null) return existing;
          }
        }
      }

      // Create new conversation
      final conversationResponse = await _supabase
          .from('conversations')
          .insert({
        'type': 'direct',
        'created_by': userId,
      })
          .select()
          .single();

      final conversationId = conversationResponse['id'];

      // Add both participants
      await _supabase.from('conversation_participants').insert([
        {'conversation_id': conversationId, 'user_id': userId},
        {'conversation_id': conversationId, 'user_id': otherUserId},
      ]);

      return Conversation.fromSupabase(conversationResponse);
    } catch (e) {
      throw Exception('Failed to create conversation: $e');
    }
  }

  /// Create a group conversation
  Future<Conversation> createGroupConversation({
    required String name,
    required List<String> participantIds,
    String? imageUrl,
  }) async {
    try {
      final userId = currentUserId;
      if (userId == null) throw Exception('User not authenticated');

      // Create conversation
      final conversationResponse = await _supabase
          .from('conversations')
          .insert({
        'name': name,
        'type': 'group',
        'image_url': imageUrl,
        'created_by': userId,
      })
          .select()
          .single();

      final conversationId = conversationResponse['id'];

      // Add all participants (including creator)
      final participants = [userId, ...participantIds]
          .map((id) => {
        'conversation_id': conversationId,
        'user_id': id,
        'is_admin': id == userId, // Creator is admin
      })
          .toList();

      await _supabase.from('conversation_participants').insert(participants);

      return Conversation.fromSupabase(conversationResponse);
    } catch (e) {
      throw Exception('Failed to create group: $e');
    }
  }

  /// Get messages for a conversation
  Future<List<Message>> getMessages(String conversationId, {int limit = 50, int offset = 0}) async {
    try {
      final response = await _supabase
          .from('messages')
          .select('''
            *,
            users:sender_id(id, email, raw_user_meta_data)
          ''')
          .eq('conversation_id', conversationId)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return (response as List).map((data) {
        final user = data['users'];
        return Message.fromSupabase({
          ...data,
          'sender_name': user?['raw_user_meta_data']?['full_name'] ?? user?['email'],
          'sender_avatar_url': user?['raw_user_meta_data']?['avatar_url'],
        });
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch messages: $e');
    }
  }

  /// Send a text message
  Future<Message> sendMessage({
    required String conversationId,
    required String content,
    String? replyToId,
  }) async {
    try {
      final userId = currentUserId;
      if (userId == null) throw Exception('User not authenticated');

      final response = await _supabase
          .from('messages')
          .insert({
        'conversation_id': conversationId,
        'sender_id': userId,
        'content': content,
        'type': 'text',
        'reply_to_id': replyToId,
      })
          .select()
          .single();

      return Message.fromSupabase(response);
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  /// Send an image message
  Future<Message> sendImageMessage({
    required String conversationId,
    required String imageUrl,
    String? caption,
  }) async {
    try {
      final userId = currentUserId;
      if (userId == null) throw Exception('User not authenticated');

      final response = await _supabase
          .from('messages')
          .insert({
        'conversation_id': conversationId,
        'sender_id': userId,
        'content': caption,
        'type': 'image',
        'media_url': imageUrl,
      })
          .select()
          .single();

      return Message.fromSupabase(response);
    } catch (e) {
      throw Exception('Failed to send image: $e');
    }
  }

  /// Delete a message
  Future<void> deleteMessage(String messageId) async {
    try {
      await _supabase
          .from('messages')
          .update({'is_deleted': true})
          .eq('id', messageId);
    } catch (e) {
      throw Exception('Failed to delete message: $e');
    }
  }

  /// Add reaction to message
  Future<void> addReaction({
    required String messageId,
    required String emoji,
  }) async {
    try {
      final userId = currentUserId;
      if (userId == null) throw Exception('User not authenticated');

      await _supabase.from('message_reactions').insert({
        'message_id': messageId,
        'user_id': userId,
        'emoji': emoji,
      });
    } catch (e) {
      throw Exception('Failed to add reaction: $e');
    }
  }

  /// Remove reaction from message
  Future<void> removeReaction({
    required String messageId,
    required String emoji,
  }) async {
    try {
      final userId = currentUserId;
      if (userId == null) throw Exception('User not authenticated');

      await _supabase
          .from('message_reactions')
          .delete()
          .eq('message_id', messageId)
          .eq('user_id', userId)
          .eq('emoji', emoji);
    } catch (e) {
      throw Exception('Failed to remove reaction: $e');
    }
  }

  /// Mark conversation as read
  Future<void> markAsRead(String conversationId) async {
    try {
      final userId = currentUserId;
      if (userId == null) throw Exception('User not authenticated');

      await _supabase
          .from('conversation_participants')
          .update({'last_read_at': DateTime.now().toIso8601String()})
          .eq('conversation_id', conversationId)
          .eq('user_id', userId);
    } catch (e) {
      throw Exception('Failed to mark as read: $e');
    }
  }

  /// Subscribe to conversation messages (real-time)
  RealtimeChannel subscribeToMessages(
      String conversationId,
      void Function(Message) onMessage,
      ) {
    return _supabase
        .channel('messages:$conversationId')
        .onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: 'messages',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'conversation_id',
        value: conversationId,
      ),
      callback: (payload) {
        final message = Message.fromSupabase(payload.newRecord);
        onMessage(message);
      },
    )
        .subscribe();
  }

  /// Subscribe to conversations list (real-time)
  RealtimeChannel subscribeToConversations(
      void Function() onUpdate,
      ) {
    final userId = currentUserId;
    if (userId == null) throw Exception('User not authenticated');

    return _supabase
        .channel('conversations:$userId')
        .onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: 'conversations',
      callback: (payload) => onUpdate(),
    )
        .subscribe();
  }

  /// Search users for creating conversations
  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    try {
      final response = await _supabase
          .rpc('search_users', params: {'search_query': query});

      return (response as List).cast<Map<String, dynamic>>();
    } catch (e) {
      throw Exception('Failed to search users: $e');
    }
  }

  /// Add participant to group
  Future<void> addParticipant(String conversationId, String userId) async {
    try {
      await _supabase.from('conversation_participants').insert({
        'conversation_id': conversationId,
        'user_id': userId,
      });
    } catch (e) {
      throw Exception('Failed to add participant: $e');
    }
  }

  /// Remove participant from group
  Future<void> removeParticipant(String conversationId, String userId) async {
    try {
      await _supabase
          .from('conversation_participants')
          .delete()
          .eq('conversation_id', conversationId)
          .eq('user_id', userId);
    } catch (e) {
      throw Exception('Failed to remove participant: $e');
    }
  }

  /// Leave conversation
  Future<void> leaveConversation(String conversationId) async {
    try {
      final userId = currentUserId;
      if (userId == null) throw Exception('User not authenticated');

      await removeParticipant(conversationId, userId);
    } catch (e) {
      throw Exception('Failed to leave conversation: $e');
    }
  }
}
