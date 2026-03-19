import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/event_chat.dart';

class PollService {
  static final PollService _instance = PollService._internal();
  factory PollService() => _instance;
  PollService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  /// Create a poll (host only)
  Future<EventPoll> createPoll({
    required String eventId,
    required String question,
    required List<String> options,
    bool allowMultipleChoices = false,
    Duration? duration,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final expiresAt = duration != null ? DateTime.now().add(duration) : null;

    final data = {
      'event_id': eventId,
      'created_by': userId,
      'question': question,
      'options': options,
      'allow_multiple_choices': allowMultipleChoices,
      'expires_at': expiresAt?.toIso8601String(),
    };

    final response = await _supabase
        .from('event_polls')
        .insert(data)
        .select()
        .single();

    return EventPoll.fromSupabase(response);
  }

  /// Get poll with live results
  Future<EventPoll> getPollWithResults(String pollId) async {
    final userId = _supabase.auth.currentUser?.id;

    // Get poll details
    final pollResponse = await _supabase
        .from('event_polls')
        .select('''
          *,
          users!created_by(full_name)
        ''')
        .eq('id', pollId)
        .single();

    // Get vote counts
    final votesResponse = await _supabase
        .from('poll_votes')
        .select('option_index')
        .eq('poll_id', pollId);

    final voteCounts = <String, int>{};
    for (final vote in votesResponse as List) {
      final optionIndex = vote['option_index'] as String;
      voteCounts[optionIndex] = (voteCounts[optionIndex] ?? 0) + 1;
    }

    // Get user's votes if authenticated
    List<String>? userVotes;
    if (userId != null) {
      final userVotesResponse = await _supabase
          .from('poll_votes')
          .select('option_index')
          .eq('poll_id', pollId)
          .eq('user_id', userId);

      userVotes = (userVotesResponse as List)
          .map((v) => v['option_index'] as String)
          .toList();
    }

    final creator = pollResponse['users'] as Map<String, dynamic>?;

    return EventPoll.fromSupabase({
      ...pollResponse,
      'creator_name': creator?['full_name'],
      'vote_counts': voteCounts,
      'user_votes': userVotes,
    });
  }

  /// Get all polls for an event
  Future<List<EventPoll>> getEventPolls(String eventId) async {
    final response = await _supabase
        .from('event_polls')
        .select('''
          *,
          users!created_by(full_name)
        ''')
        .eq('event_id', eventId)
        .order('created_at', ascending: false);

    final polls = <EventPoll>[];
    for (final item in response as List) {
      final pollId = item['id'] as String;
      final poll = await getPollWithResults(pollId);
      polls.add(poll);
    }

    return polls;
  }

  /// Vote on a poll
  Future<void> vote({
    required String pollId,
    required String optionIndex,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    // Get poll to check if multiple choices allowed
    final poll = await _supabase
        .from('event_polls')
        .select('allow_multiple_choices')
        .eq('id', pollId)
        .single();

    final allowMultiple = poll['allow_multiple_choices'] as bool;

    // If single choice, delete existing votes
    if (!allowMultiple) {
      await _supabase
          .from('poll_votes')
          .delete()
          .eq('poll_id', pollId)
          .eq('user_id', userId);
    }

    // Add new vote
    await _supabase.from('poll_votes').insert({
      'poll_id': pollId,
      'user_id': userId,
      'option_index': optionIndex,
    });
  }

  /// Remove vote
  Future<void> removeVote({
    required String pollId,
    required String optionIndex,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    await _supabase
        .from('poll_votes')
        .delete()
        .eq('poll_id', pollId)
        .eq('user_id', userId)
        .eq('option_index', optionIndex);
  }

  /// Close poll (host only)
  Future<void> closePoll(String pollId) async {
    await _supabase
        .from('event_polls')
        .update({'is_active': false})
        .eq('id', pollId);
  }

  /// Subscribe to poll results updates
  RealtimeChannel subscribeToPollResults(
    String pollId,
    void Function(EventPoll) onUpdate,
  ) {
    return _supabase
        .channel('poll_$pollId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'poll_votes',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'poll_id',
            value: pollId,
          ),
          callback: (payload) async {
            final updatedPoll = await getPollWithResults(pollId);
            onUpdate(updatedPoll);
          },
        )
        .subscribe();
  }
}
