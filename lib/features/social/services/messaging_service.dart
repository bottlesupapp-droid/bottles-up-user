import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/social_models.dart';

class MessagingService {
  static final MessagingService _instance = MessagingService._internal();
  factory MessagingService() => _instance;
  MessagingService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Create or get direct conversation
  Future<Conversation> getOrCreateDirectConversation(String userId) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Check if conversation already exists
      final existing = await _supabase.rpc('get_or_create_direct_conversation', params: {
        'user_id_1': currentUser.id,
        'user_id_2': userId,
      });

      if (existing != null) {
        return Conversation.fromSupabase(existing as Map<String, dynamic>);
      }

      // Create new conversation
      final response = await _supabase.from('conversations').insert({
        'type': ConversationType.direct.name,
        'participant_ids': [currentUser.id, userId],
      }).select().single();

      return Conversation.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to get or create conversation: $e');
    }
  }

  // Create group conversation
  Future<Conversation> createGroupConversation({
    required String name,
    required List<String> participantIds,
    String? avatarUrl,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Add current user to participants if not included
      final participants = participantIds.toSet()..add(currentUser.id);

      final response = await _supabase.from('conversations').insert({
        'type': ConversationType.group.name,
        'name': name,
        'avatar_url': avatarUrl,
        'participant_ids': participants.toList(),
      }).select().single();

      return Conversation.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to create group conversation: $e');
    }
  }

  // Get user conversations
  Future<List<Conversation>> getConversations({
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return [];

      final response = await _supabase
          .from('conversations')
          .select('*, participants:users!inner(*)')
          .contains('participant_ids', [currentUser.id])
          .order('last_message_at', ascending: false)
          .range(offset, offset + limit - 1);

      return (response as List)
          .map((item) => Conversation.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Send message
  Future<Message> sendMessage({
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

      final response = await _supabase.from('messages').insert({
        'conversation_id': conversationId,
        'sender_id': currentUser.id,
        'content': content,
        'message_type': messageType,
        'status': MessageStatus.sent.name,
        'attachments': attachments ?? [],
        'metadata': metadata,
      }).select().single();

      // Update conversation last message
      await _supabase.from('conversations').update({
        'last_message_at': DateTime.now().toIso8601String(),
        'last_message': content,
      }).eq('id', conversationId);

      return Message.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  // Get messages
  Future<List<Message>> getMessages({
    required String conversationId,
    int limit = 50,
    String? beforeMessageId,
  }) async {
    try {
      var query = _supabase
          .from('messages')
          .select('*, sender:users!sender_id(*)')
          .eq('conversation_id', conversationId)
          .order('sent_at', ascending: false)
          .limit(limit);

      if (beforeMessageId != null) {
        final beforeMessage = await _supabase
            .from('messages')
            .select('sent_at')
            .eq('id', beforeMessageId)
            .single();

        query = query.lt('sent_at', beforeMessage['sent_at']);
      }

      final response = await query;

      return (response as List)
          .map((item) => Message.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Mark message as read
  Future<void> markMessageAsRead(String messageId) async {
    try {
      await _supabase.from('messages').update({
        'status': MessageStatus.read.name,
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

      await _supabase.from('messages').update({
        'status': MessageStatus.read.name,
        'read_at': DateTime.now().toIso8601String(),
      }).eq('conversation_id', conversationId).neq('sender_id', currentUser.id);
    } catch (e) {
      // Non-critical error
    }
  }

  // Edit message
  Future<Message> editMessage({
    required String messageId,
    required String newContent,
  }) async {
    try {
      final response = await _supabase.from('messages').update({
        'content': newContent,
        'is_edited': true,
        'edited_at': DateTime.now().toIso8601String(),
      }).eq('id', messageId).select().single();

      return Message.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to edit message: $e');
    }
  }

  // Delete message
  Future<void> deleteMessage(String messageId) async {
    try {
      await _supabase.from('messages').delete().eq('id', messageId);
    } catch (e) {
      throw Exception('Failed to delete message: $e');
    }
  }

  // Get unread count
  Future<int> getUnreadCount() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return 0;

      final response = await _supabase.rpc('get_total_unread_count', params: {
        'user_id_param': currentUser.id,
      });

      return response as int? ?? 0;
    } catch (e) {
      return 0;
    }
  }

  // Search messages
  Future<List<Message>> searchMessages({
    required String query,
    String? conversationId,
    int limit = 50,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return [];

      var dbQuery = _supabase
          .from('messages')
          .select('*, sender:users!sender_id(*)')
          .textSearch('content', query)
          .limit(limit);

      if (conversationId != null) {
        dbQuery = dbQuery.eq('conversation_id', conversationId);
      } else {
        // Only search in user's conversations
        final conversations = await getConversations();
        final conversationIds = conversations.map((c) => c.id).toList();
        if (conversationIds.isEmpty) return [];
        dbQuery = dbQuery.in_('conversation_id', conversationIds);
      }

      final response = await dbQuery.order('sent_at', ascending: false);

      return (response as List)
          .map((item) => Message.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Add participant to group
  Future<void> addParticipant({
    required String conversationId,
    required String userId,
  }) async {
    try {
      final conversation = await _supabase
          .from('conversations')
          .select('participant_ids')
          .eq('id', conversationId)
          .single();

      final participants = List<String>.from(conversation['participant_ids'] as List);
      if (!participants.contains(userId)) {
        participants.add(userId);

        await _supabase.from('conversations').update({
          'participant_ids': participants,
        }).eq('id', conversationId);
      }
    } catch (e) {
      throw Exception('Failed to add participant: $e');
    }
  }

  // Remove participant from group
  Future<void> removeParticipant({
    required String conversationId,
    required String userId,
  }) async {
    try {
      final conversation = await _supabase
          .from('conversations')
          .select('participant_ids')
          .eq('id', conversationId)
          .single();

      final participants = List<String>.from(conversation['participant_ids'] as List);
      participants.remove(userId);

      await _supabase.from('conversations').update({
        'participant_ids': participants,
      }).eq('id', conversationId);
    } catch (e) {
      throw Exception('Failed to remove participant: $e');
    }
  }

  // Leave group conversation
  Future<void> leaveConversation(String conversationId) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return;

      await removeParticipant(
        conversationId: conversationId,
        userId: currentUser.id,
      );
    } catch (e) {
      throw Exception('Failed to leave conversation: $e');
    }
  }

  // Update group conversation
  Future<Conversation> updateGroupConversation({
    required String conversationId,
    String? name,
    String? avatarUrl,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;

      final response = await _supabase
          .from('conversations')
          .update(updates)
          .eq('id', conversationId)
          .select()
          .single();

      return Conversation.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to update conversation: $e');
    }
  }

  // Delete conversation (for current user)
  Future<void> deleteConversation(String conversationId) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return;

      // For direct messages, just hide for current user
      // For groups, remove participant
      final conversation = await _supabase
          .from('conversations')
          .select('type')
          .eq('id', conversationId)
          .single();

      if (conversation['type'] == ConversationType.group.name) {
        await leaveConversation(conversationId);
      } else {
        // Create a deleted_conversations record
        await _supabase.from('deleted_conversations').insert({
          'user_id': currentUser.id,
          'conversation_id': conversationId,
        });
      }
    } catch (e) {
      throw Exception('Failed to delete conversation: $e');
    }
  }
}
