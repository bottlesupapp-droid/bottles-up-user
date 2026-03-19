import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/conversation.dart';
import '../models/message.dart';
import '../services/messaging_service.dart';

part 'messaging_provider.g.dart';

/// Provider for MessagingService instance
@riverpod
MessagingService messagingService(MessagingServiceRef ref) {
  return MessagingService();
}

/// Provider to get all conversations for the current user
@riverpod
Future<List<Conversation>> conversations(ConversationsRef ref) async {
  final service = ref.watch(messagingServiceProvider);
  return service.getConversations();
}

/// Provider to get a specific conversation by ID
@riverpod
Future<Conversation?> conversation(ConversationRef ref, String conversationId) async {
  final service = ref.watch(messagingServiceProvider);
  return service.getConversation(conversationId);
}

/// Provider to get messages for a conversation
@riverpod
Future<List<Message>> conversationMessages(
  ConversationMessagesRef ref,
  String conversationId, {
  int limit = 50,
  int offset = 0,
}) async {
  final service = ref.watch(messagingServiceProvider);
  return service.getMessages(conversationId, limit: limit, offset: offset);
}

/// Provider to search users
@riverpod
Future<List<Map<String, dynamic>>> searchUsers(
  SearchUsersRef ref,
  String query,
) async {
  if (query.isEmpty) return [];
  final service = ref.watch(messagingServiceProvider);
  return service.searchUsers(query);
}

/// StateNotifier for managing real-time messages in a conversation
@riverpod
class ConversationMessagesNotifier extends _$ConversationMessagesNotifier {
  RealtimeChannel? _subscription;
  String? _currentConversationId;

  @override
  Future<List<Message>> build(String conversationId) async {
    _currentConversationId = conversationId;

    // Cancel subscription when provider is disposed
    ref.onDispose(() {
      _subscription?.unsubscribe();
    });

    final service = ref.watch(messagingServiceProvider);

    // Subscribe to real-time messages
    _subscription = service.subscribeToMessages(
      conversationId,
      (newMessage) {
        // Add new message to the list
        state.whenData((messages) {
          state = AsyncValue.data([newMessage, ...messages]);
        });
      },
    );

    // Get initial messages
    return service.getMessages(conversationId);
  }

  /// Send a text message
  Future<void> sendMessage(String content, {String? replyToId}) async {
    if (_currentConversationId == null) return;

    final service = ref.read(messagingServiceProvider);
    try {
      await service.sendMessage(
        conversationId: _currentConversationId!,
        content: content,
        replyToId: replyToId,
      );
    } catch (e) {
      // Handle error
      rethrow;
    }
  }

  /// Send an image message
  Future<void> sendImageMessage(String imageUrl, {String? caption}) async {
    if (_currentConversationId == null) return;

    final service = ref.read(messagingServiceProvider);
    try {
      await service.sendImageMessage(
        conversationId: _currentConversationId!,
        imageUrl: imageUrl,
        caption: caption,
      );
    } catch (e) {
      // Handle error
      rethrow;
    }
  }

  /// Delete a message
  Future<void> deleteMessage(String messageId) async {
    final service = ref.read(messagingServiceProvider);
    try {
      await service.deleteMessage(messageId);

      // Remove message from local state
      state.whenData((messages) {
        state = AsyncValue.data(
          messages.where((m) => m.id != messageId).toList(),
        );
      });
    } catch (e) {
      // Handle error
      rethrow;
    }
  }

  /// Add reaction to message
  Future<void> addReaction(String messageId, String emoji) async {
    final service = ref.read(messagingServiceProvider);
    try {
      await service.addReaction(messageId: messageId, emoji: emoji);
    } catch (e) {
      // Handle error
      rethrow;
    }
  }

  /// Remove reaction from message
  Future<void> removeReaction(String messageId, String emoji) async {
    final service = ref.read(messagingServiceProvider);
    try {
      await service.removeReaction(messageId: messageId, emoji: emoji);
    } catch (e) {
      // Handle error
      rethrow;
    }
  }

  /// Mark conversation as read
  Future<void> markAsRead() async {
    if (_currentConversationId == null) return;

    final service = ref.read(messagingServiceProvider);
    try {
      await service.markAsRead(_currentConversationId!);
    } catch (e) {
      // Handle error
      rethrow;
    }
  }

  /// Load more messages (pagination)
  Future<void> loadMoreMessages() async {
    if (_currentConversationId == null) return;

    final currentMessages = state.value ?? [];
    final service = ref.read(messagingServiceProvider);

    try {
      final moreMessages = await service.getMessages(
        _currentConversationId!,
        limit: 50,
        offset: currentMessages.length,
      );

      state = AsyncValue.data([...currentMessages, ...moreMessages]);
    } catch (e) {
      // Handle error
      rethrow;
    }
  }
}

/// StateNotifier for managing conversations list with real-time updates
@riverpod
class ConversationsNotifier extends _$ConversationsNotifier {
  RealtimeChannel? _subscription;

  @override
  Future<List<Conversation>> build() async {
    // Cancel subscription when provider is disposed
    ref.onDispose(() {
      _subscription?.unsubscribe();
    });

    final service = ref.watch(messagingServiceProvider);

    // Subscribe to real-time conversation updates
    _subscription = service.subscribeToConversations(() {
      // Refresh conversations when there's an update
      ref.invalidateSelf();
    });

    return service.getConversations();
  }

  /// Create a direct conversation with another user
  Future<Conversation> createDirectConversation(String otherUserId) async {
    final service = ref.read(messagingServiceProvider);
    try {
      final conversation = await service.createDirectConversation(otherUserId);

      // Refresh conversations list
      ref.invalidateSelf();

      return conversation;
    } catch (e) {
      rethrow;
    }
  }

  /// Create a group conversation
  Future<Conversation> createGroupConversation({
    required String name,
    required List<String> participantIds,
    String? imageUrl,
  }) async {
    final service = ref.read(messagingServiceProvider);
    try {
      final conversation = await service.createGroupConversation(
        name: name,
        participantIds: participantIds,
        imageUrl: imageUrl,
      );

      // Refresh conversations list
      ref.invalidateSelf();

      return conversation;
    } catch (e) {
      rethrow;
    }
  }

  /// Add participant to group
  Future<void> addParticipant(String conversationId, String userId) async {
    final service = ref.read(messagingServiceProvider);
    try {
      await service.addParticipant(conversationId, userId);

      // Refresh conversations list
      ref.invalidateSelf();
    } catch (e) {
      rethrow;
    }
  }

  /// Remove participant from group
  Future<void> removeParticipant(String conversationId, String userId) async {
    final service = ref.read(messagingServiceProvider);
    try {
      await service.removeParticipant(conversationId, userId);

      // Refresh conversations list
      ref.invalidateSelf();
    } catch (e) {
      rethrow;
    }
  }

  /// Leave conversation
  Future<void> leaveConversation(String conversationId) async {
    final service = ref.read(messagingServiceProvider);
    try {
      await service.leaveConversation(conversationId);

      // Refresh conversations list
      ref.invalidateSelf();
    } catch (e) {
      rethrow;
    }
  }
}
