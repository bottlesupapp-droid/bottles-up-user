import 'package:flutter/material.dart';
import '../models/enhanced_poll.dart';
import '../services/enhanced_poll_service.dart';
import 'dart:async';

class EnhancedPollCard extends StatefulWidget {
  final EnhancedPoll poll;
  final Function()? onVoted;

  const EnhancedPollCard({
    super.key,
    required this.poll,
    this.onVoted,
  });

  @override
  State<EnhancedPollCard> createState() => _EnhancedPollCardState();
}

class _EnhancedPollCardState extends State<EnhancedPollCard> {
  final _pollService = EnhancedPollService();
  PollResults? _results;
  bool _isLoading = true;
  Set<String> _selectedOptions = {};
  Timer? _countdownTimer;
  Duration? _timeRemaining;

  @override
  void initState() {
    super.initState();
    _loadResults();
    _startCountdownTimer();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startCountdownTimer() {
    if (widget.poll.closesAt == null) return;

    _timeRemaining = _pollService.getTimeRemaining(widget.poll);
    if (_timeRemaining == null || _timeRemaining! <= Duration.zero) return;

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeRemaining = _pollService.getTimeRemaining(widget.poll);
        if (_timeRemaining == null || _timeRemaining! <= Duration.zero) {
          timer.cancel();
        }
      });
    });
  }

  Future<void> _loadResults() async {
    try {
      final results = await _pollService.getPollResults(widget.poll.id);
      setState(() {
        _results = results;
        _isLoading = false;
        _selectedOptions = Set.from(results.userVotedOptionIds ?? []);
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _submitVote() async {
    if (_selectedOptions.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      await _pollService.vote(
        pollId: widget.poll.id,
        optionIds: _selectedOptions.toList(),
        isAnonymous: widget.poll.isAnonymous,
      );

      await _loadResults();
      widget.onVoted?.call();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vote submitted!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isClosed = _pollService.isPollClosed(widget.poll);
    final hasVoted = _results?.hasUserVoted ?? false;
    final showResults = isClosed || hasVoted;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poll header
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: widget.poll.createdByAvatar != null
                      ? NetworkImage(widget.poll.createdByAvatar!)
                      : null,
                  child: widget.poll.createdByAvatar == null
                      ? const Icon(Icons.person, size: 16)
                      : null,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.poll.createdByName ?? 'Unknown',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        _formatPollType(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
                if (widget.poll.isAnonymous)
                  Chip(
                    label: const Text('Anonymous', style: TextStyle(fontSize: 11)),
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Question
            Text(
              widget.poll.question,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            // Countdown timer
            if (_timeRemaining != null && _timeRemaining! > Duration.zero) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.timer,
                      size: 16,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Closes in ${_formatDuration(_timeRemaining!)}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Options
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (showResults && _results != null)
              ..._buildResultsOptions()
            else
              ..._buildVotingOptions(),

            // Actions
            if (!showResults && !_isLoading) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _selectedOptions.isEmpty ? null : _submitVote,
                  child: const Text('Submit Vote'),
                ),
              ),
            ],

            // Total votes
            if (_results != null) ...[
              const SizedBox(height: 12),
              Text(
                '${_results!.totalVotes} ${_results!.totalVotes == 1 ? 'vote' : 'votes'}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _buildVotingOptions() {
    return widget.poll.options.map((option) {
      final isSelected = _selectedOptions.contains(option.id);
      final isSingleChoice = widget.poll.pollType == PollType.single;

      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: InkWell(
          onTap: () {
            setState(() {
              if (isSingleChoice) {
                _selectedOptions = {option.id};
              } else {
                if (isSelected) {
                  _selectedOptions.remove(option.id);
                } else {
                  _selectedOptions.add(option.id);
                }
              }
            });
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
              color: isSelected
                  ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  isSingleChoice
                      ? (isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked)
                      : (isSelected ? Icons.check_box : Icons.check_box_outline_blank),
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    option.optionText,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildResultsOptions() {
    return _results!.options.map((result) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      if (result.isUserVote)
                        Icon(
                          Icons.check_circle,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      if (result.isUserVote) const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          result.optionText,
                          style: TextStyle(
                            fontWeight: result.isUserVote
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${result.votes} (${result.percentage.toStringAsFixed(1)}%)',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: result.percentage / 100,
                minHeight: 8,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation(
                  result.isUserVote
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey[400],
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  String _formatPollType() {
    final type = widget.poll.pollType == PollType.multiple
        ? 'Multiple choice'
        : 'Single choice';
    return type;
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours % 24}h';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    } else {
      return '${duration.inSeconds}s';
    }
  }
}
