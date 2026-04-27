import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/chat_reaction.dart';

class ChatReactionService {
  static final ChatReactionService _instance = ChatReactionService._internal();
  factory ChatReactionService() => _instance;
  ChatReactionService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Add reaction to a message
  Future<ChatReaction> addReaction({
    required String messageId,
    required String emoji,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Check if user already reacted with this emoji
      final existing = await _supabase
          .from('chat_reactions')
          .select()
          .eq('message_id', messageId)
          .eq('user_id', currentUser.id)
          .eq('emoji', emoji)
          .maybeSingle();

      if (existing != null) {
        // Already reacted, return existing
        return ChatReaction.fromSupabase(existing);
      }

      final reactionData = {
        'message_id': messageId,
        'user_id': currentUser.id,
        'user_name': currentUser.userMetadata?['full_name'] ?? 'Unknown',
        'user_avatar': currentUser.userMetadata?['avatar_url'],
        'emoji': emoji,
      };

      final response = await _supabase
          .from('chat_reactions')
          .insert(reactionData)
          .select()
          .single();

      return ChatReaction.fromSupabase(response);
    } catch (e) {
      throw Exception('Failed to add reaction: $e');
    }
  }

  // Remove reaction from a message
  Future<void> removeReaction({
    required String messageId,
    required String emoji,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      await _supabase
          .from('chat_reactions')
          .delete()
          .eq('message_id', messageId)
          .eq('user_id', currentUser.id)
          .eq('emoji', emoji);
    } catch (e) {
      throw Exception('Failed to remove reaction: $e');
    }
  }

  // Toggle reaction (add if not exists, remove if exists)
  Future<bool> toggleReaction({
    required String messageId,
    required String emoji,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final existing = await _supabase
          .from('chat_reactions')
          .select()
          .eq('message_id', messageId)
          .eq('user_id', currentUser.id)
          .eq('emoji', emoji)
          .maybeSingle();

      if (existing != null) {
        // Remove reaction
        await removeReaction(messageId: messageId, emoji: emoji);
        return false;
      } else {
        // Add reaction
        await addReaction(messageId: messageId, emoji: emoji);
        return true;
      }
    } catch (e) {
      throw Exception('Failed to toggle reaction: $e');
    }
  }

  // Get all reactions for a message
  Future<List<ChatReaction>> getMessageReactions(String messageId) async {
    try {
      final response = await _supabase
          .from('chat_reactions')
          .select()
          .eq('message_id', messageId)
          .order('created_at', ascending: true);

      return (response as List)
          .map((data) => ChatReaction.fromSupabase(data))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get reaction summary for a message
  Future<MessageReactionSummary> getReactionSummary(String messageId) async {
    final reactions = await getMessageReactions(messageId);
    return MessageReactionSummary.fromReactions(messageId, reactions);
  }

  // Get reactions for multiple messages at once
  Future<Map<String, MessageReactionSummary>> getReactionsForMessages(
    List<String> messageIds,
  ) async {
    try {
      if (messageIds.isEmpty) return {};

      final response = await _supabase
          .from('chat_reactions')
          .select()
          .inFilter('message_id', messageIds);

      final reactions = (response as List)
          .map((data) => ChatReaction.fromSupabase(data))
          .toList();

      final summaries = <String, MessageReactionSummary>{};
      for (final messageId in messageIds) {
        final messageReactions =
            reactions.where((r) => r.messageId == messageId).toList();
        summaries[messageId] =
            MessageReactionSummary.fromReactions(messageId, messageReactions);
      }

      return summaries;
    } catch (e) {
      return {};
    }
  }

  // Check if current user reacted to a message with specific emoji
  Future<bool> hasUserReacted({
    required String messageId,
    required String emoji,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return false;

      final response = await _supabase
          .from('chat_reactions')
          .select()
          .eq('message_id', messageId)
          .eq('user_id', currentUser.id)
          .eq('emoji', emoji)
          .maybeSingle();

      return response != null;
    } catch (e) {
      return false;
    }
  }

  // Subscribe to real-time reaction updates for a message
  RealtimeChannel subscribeToMessageReactions(
    String messageId,
    void Function(MessageReactionSummary) onUpdate,
  ) {
    return _supabase
        .channel('reactions_$messageId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'chat_reactions',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'message_id',
            value: messageId,
          ),
          callback: (payload) async {
            final summary = await getReactionSummary(messageId);
            onUpdate(summary);
          },
        )
        .subscribe();
  }
}
