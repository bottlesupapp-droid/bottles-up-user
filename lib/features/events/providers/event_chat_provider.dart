import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/event_chat.dart';
import '../services/event_chat_service.dart';

part 'event_chat_provider.g.dart';

// Event Chat Messages Provider
@riverpod
class EventChatMessages extends _$EventChatMessages {
  RealtimeChannel? _channel;

  @override
  Future<List<EventChatMessage>> build(String eventId) async {
    final messages = await EventChatService().getEventMessages(eventId);

    // Subscribe to real-time updates
    _channel = EventChatService().subscribeToEventChat(
      eventId,
      (newMessage) {
        state.whenData((currentMessages) {
          state = AsyncValue.data([newMessage, ...currentMessages]);
        });
      },
    );

    ref.onDispose(() {
      _channel?.unsubscribe();
    });

    return messages;
  }

  Future<void> sendMessage({
    required String eventId,
    required String message,
    String? replyToId,
    List<String>? images,
  }) async {
    await EventChatService().sendMessage(
      eventId: eventId,
      message: message,
      replyToId: replyToId,
      images: images,
    );
    // Real-time subscription will update the state
  }

  Future<void> deleteMessage(String messageId) async {
    await EventChatService().deleteMessage(messageId);
    ref.invalidateSelf();
  }

  Future<void> togglePinMessage(String messageId, bool isPinned) async {
    await EventChatService().togglePinMessage(messageId, isPinned);
    ref.invalidateSelf();
  }

  Future<void> loadMore(int offset) async {
    final moreMessages = await EventChatService().getEventMessages(
      eventId,
      limit: 50,
      offset: offset,
    );

    state.whenData((currentMessages) {
      state = AsyncValue.data([...currentMessages, ...moreMessages]);
    });
  }
}

// Pinned Messages Provider
@riverpod
class PinnedMessages extends _$PinnedMessages {
  @override
  Future<List<EventChatMessage>> build(String eventId) async {
    return EventChatService().getPinnedMessages(eventId);
  }
}
