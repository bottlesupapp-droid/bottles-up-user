import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/event_chat.dart';
import '../services/poll_service.dart';

part 'poll_provider.g.dart';

// Event Polls Provider
@riverpod
class EventPolls extends _$EventPolls {
  @override
  Future<List<EventPoll>> build(String eventId) async {
    return PollService().getEventPolls(eventId);
  }

  Future<void> createPoll({
    required String eventId,
    required String question,
    required List<String> options,
    bool allowMultipleChoices = false,
    Duration? duration,
  }) async {
    await PollService().createPoll(
      eventId: eventId,
      question: question,
      options: options,
      allowMultipleChoices: allowMultipleChoices,
      duration: duration,
    );
    ref.invalidateSelf();
  }

  Future<void> closePoll(String pollId) async {
    await PollService().closePoll(pollId);
    ref.invalidateSelf();
  }
}

// Poll Detail with Live Results Provider
@riverpod
class PollDetail extends _$PollDetail {
  RealtimeChannel? _channel;

  @override
  Future<EventPoll> build(String pollId) async {
    final poll = await PollService().getPollWithResults(pollId);

    // Subscribe to real-time vote updates
    _channel = PollService().subscribeToPollResults(
      pollId,
      (updatedPoll) {
        state = AsyncValue.data(updatedPoll);
      },
    );

    ref.onDispose(() {
      _channel?.unsubscribe();
    });

    return poll;
  }

  Future<void> vote(String optionIndex) async {
    await PollService().vote(
      pollId: pollId,
      optionIndex: optionIndex,
    );
    // Real-time subscription will update the state
  }

  Future<void> removeVote(String optionIndex) async {
    await PollService().removeVote(
      pollId: pollId,
      optionIndex: optionIndex,
    );
    // Real-time subscription will update the state
  }
}
