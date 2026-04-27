import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/enhanced_poll.dart';

class EnhancedPollService {
  static final EnhancedPollService _instance = EnhancedPollService._internal();
  factory EnhancedPollService() => _instance;
  EnhancedPollService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Create a new poll
  Future<EnhancedPoll> createPoll({
    required String eventId,
    required String question,
    required List<String> options,
    PollType pollType = PollType.single,
    bool isAnonymous = false,
    DateTime? closesAt,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Create poll
      final pollData = {
        'event_id': eventId,
        'question': question,
        'poll_type': pollType.name,
        'is_anonymous': isAnonymous,
        'closes_at': closesAt?.toIso8601String(),
        'created_by': currentUser.id,
        'created_by_name': currentUser.userMetadata?['full_name'],
        'created_by_avatar': currentUser.userMetadata?['avatar_url'],
        'status': PollStatus.active.name,
      };

      final pollResponse = await _supabase
          .from('event_polls')
          .insert(pollData)
          .select()
          .single();

      final pollId = pollResponse['id'] as String;

      // Create poll options
      final optionsData = options
          .map((text) => {
                'poll_id': pollId,
                'option_text': text,
                'votes_count': 0,
              })
          .toList();

      final optionsResponse = await _supabase
          .from('poll_options')
          .insert(optionsData)
          .select();

      final pollOptions = (optionsResponse as List)
          .map((data) => PollOption.fromSupabase(data))
          .toList();

      return EnhancedPoll.fromSupabase(pollResponse).copyWith(
        options: pollOptions,
      );
    } catch (e) {
      throw Exception('Failed to create poll: $e');
    }
  }

  // Get poll by ID with options
  Future<EnhancedPoll> getPoll(String pollId) async {
    try {
      final pollResponse = await _supabase
          .from('event_polls')
          .select()
          .eq('id', pollId)
          .single();

      final optionsResponse = await _supabase
          .from('poll_options')
          .select()
          .eq('poll_id', pollId)
          .order('created_at', ascending: true);

      final options = (optionsResponse as List)
          .map((data) => PollOption.fromSupabase(data))
          .toList();

      return EnhancedPoll.fromSupabase(pollResponse).copyWith(
        options: options,
      );
    } catch (e) {
      throw Exception('Failed to get poll: $e');
    }
  }

  // Get all polls for an event
  Future<List<EnhancedPoll>> getEventPolls(String eventId) async {
    try {
      final pollsResponse = await _supabase
          .from('event_polls')
          .select()
          .eq('event_id', eventId)
          .order('created_at', ascending: false);

      final polls = <EnhancedPoll>[];
      for (final pollData in pollsResponse as List) {
        final pollId = pollData['id'] as String;

        final optionsResponse = await _supabase
            .from('poll_options')
            .select()
            .eq('poll_id', pollId)
            .order('created_at', ascending: true);

        final options = (optionsResponse as List)
            .map((data) => PollOption.fromSupabase(data))
            .toList();

        polls.add(
          EnhancedPoll.fromSupabase(pollData).copyWith(options: options),
        );
      }

      return polls;
    } catch (e) {
      return [];
    }
  }

  // Vote on a poll
  Future<void> vote({
    required String pollId,
    required List<String> optionIds,
    bool isAnonymous = false,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;

      // For anonymous votes, userId can be null
      final userId = isAnonymous ? null : currentUser?.id;
      final userName = isAnonymous ? null : currentUser?.userMetadata?['full_name'];

      // Check if already voted (only for non-anonymous)
      if (!isAnonymous && userId != null) {
        final existing = await _supabase
            .from('poll_votes')
            .select()
            .eq('poll_id', pollId)
            .eq('user_id', userId)
            .maybeSingle();

        if (existing != null) {
          // Remove existing vote
          await _supabase
              .from('poll_votes')
              .delete()
              .eq('poll_id', pollId)
              .eq('user_id', userId);
        }
      }

      // Add new votes
      final votesData = optionIds
          .map((optionId) => {
                'poll_id': pollId,
                'option_id': optionId,
                'user_id': userId,
                'user_name': userName,
              })
          .toList();

      await _supabase.from('poll_votes').insert(votesData);

      // Update vote counts
      for (final optionId in optionIds) {
        await _supabase.rpc('increment_poll_vote_count', params: {
          'option_id': optionId,
        });
      }
    } catch (e) {
      throw Exception('Failed to vote: $e');
    }
  }

  // Get poll results
  Future<PollResults> getPollResults(String pollId) async {
    try {
      final currentUser = _supabase.auth.currentUser;

      // Get poll and options
      final poll = await getPoll(pollId);

      // Get user's votes
      List<String> userVotedOptionIds = [];
      if (currentUser != null && !poll.isAnonymous) {
        final userVotes = await _supabase
            .from('poll_votes')
            .select('option_id')
            .eq('poll_id', pollId)
            .eq('user_id', currentUser.id);

        userVotedOptionIds = (userVotes as List)
            .map((v) => v['option_id'] as String)
            .toList();
      }

      // Calculate results
      int totalVotes = 0;
      for (final option in poll.options) {
        totalVotes += option.votesCount;
      }

      final optionResults = poll.options.map((option) {
        final percentage = totalVotes > 0
            ? (option.votesCount / totalVotes) * 100
            : 0.0;

        return PollOptionResult(
          optionId: option.id,
          optionText: option.optionText,
          votes: option.votesCount,
          percentage: percentage,
          isUserVote: userVotedOptionIds.contains(option.id),
        );
      }).toList();

      return PollResults(
        pollId: pollId,
        options: optionResults,
        totalVotes: totalVotes,
        hasUserVoted: userVotedOptionIds.isNotEmpty,
        userVotedOptionIds: userVotedOptionIds,
      );
    } catch (e) {
      throw Exception('Failed to get results: $e');
    }
  }

  // Close a poll
  Future<void> closePoll(String pollId) async {
    try {
      await _supabase
          .from('event_polls')
          .update({
            'status': PollStatus.closed.name,
            'closes_at': DateTime.now().toIso8601String(),
          })
          .eq('id', pollId);
    } catch (e) {
      throw Exception('Failed to close poll: $e');
    }
  }

  // Delete a poll
  Future<void> deletePoll(String pollId) async {
    try {
      // Delete votes first
      await _supabase
          .from('poll_votes')
          .delete()
          .eq('poll_id', pollId);

      // Delete options
      await _supabase
          .from('poll_options')
          .delete()
          .eq('poll_id', pollId);

      // Delete poll
      await _supabase
          .from('event_polls')
          .delete()
          .eq('id', pollId);
    } catch (e) {
      throw Exception('Failed to delete poll: $e');
    }
  }

  // Check if poll is closed
  bool isPollClosed(EnhancedPoll poll) {
    if (poll.status == PollStatus.closed) return true;
    if (poll.closesAt != null && DateTime.now().isAfter(poll.closesAt!)) {
      return true;
    }
    return false;
  }

  // Get time remaining for poll
  Duration? getTimeRemaining(EnhancedPoll poll) {
    if (poll.closesAt == null) return null;
    final now = DateTime.now();
    if (now.isAfter(poll.closesAt!)) return Duration.zero;
    return poll.closesAt!.difference(now);
  }

  // Subscribe to poll updates
  RealtimeChannel subscribeToPollUpdates(
    String pollId,
    void Function(PollResults) onUpdate,
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
            final results = await getPollResults(pollId);
            onUpdate(results);
          },
        )
        .subscribe();
  }
}
