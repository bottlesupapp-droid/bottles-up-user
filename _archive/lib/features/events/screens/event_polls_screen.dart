import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../providers/poll_provider.dart';
import '../models/event_chat.dart';

class EventPollsScreen extends ConsumerWidget {
  final String eventId;
  final String eventName;

  const EventPollsScreen({
    super.key,
    required this.eventId,
    required this.eventName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pollsAsync = ref.watch(eventPollsProvider(eventId));

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(eventName),
            const Text(
              'Polls',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
      body: pollsAsync.when(
        data: (polls) {
          if (polls.isEmpty) {
            return const Center(
              child: Text('No polls yet'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: polls.length,
            itemBuilder: (context, index) {
              final poll = polls[index];
              return _PollCard(poll: poll, eventId: eventId);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreatePollDialog(context, ref),
        icon: const Icon(Icons.poll),
        label: const Text('Create Poll'),
      ),
    );
  }

  void _showCreatePollDialog(BuildContext context, WidgetRef ref) {
    final questionController = TextEditingController();
    final optionControllers = List.generate(4, (_) => TextEditingController());
    bool allowMultiple = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Create Poll'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: questionController,
                    decoration: const InputDecoration(
                      labelText: 'Question',
                      hintText: 'What would you like to ask?',
                    ),
                  ),
                  const Gap(16),
                  ...List.generate(optionControllers.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: TextField(
                        controller: optionControllers[index],
                        decoration: InputDecoration(
                          labelText: 'Option ${index + 1}',
                          hintText: 'Enter option',
                        ),
                      ),
                    );
                  }),
                  const Gap(8),
                  SwitchListTile(
                    title: const Text('Allow multiple choices'),
                    value: allowMultiple,
                    onChanged: (value) => setState(() => allowMultiple = value),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final options = optionControllers
                      .map((c) => c.text.trim())
                      .where((text) => text.isNotEmpty)
                      .toList();

                  if (questionController.text.isNotEmpty && options.length >= 2) {
                    await ref.read(eventPollsProvider(eventId).notifier).createPoll(
                          eventId: eventId,
                          question: questionController.text,
                          options: options,
                          allowMultipleChoices: allowMultiple,
                        );
                    if (context.mounted) Navigator.pop(context);
                  }
                },
                child: const Text('Create'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PollCard extends ConsumerWidget {
  final dynamic poll;
  final String eventId;

  const _PollCard({required this.poll, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pollDetailAsync = ref.watch(pollDetailProvider(poll.id));

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question
            Text(
              poll.question,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Gap(4),
            Text(
              poll.allowMultipleChoices ? 'Multiple choices allowed' : 'Single choice',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const Gap(16),

            // Options with live results
            pollDetailAsync.when(
              data: (livePoll) {
                return Column(
                  children: List.generate(livePoll.options.length, (index) {
                    final option = livePoll.options[index];
                    final percentage = livePoll.getOptionPercentage(index.toString());
                    final voteCount = livePoll.voteCounts?[index.toString()] ?? 0;
                    final hasVoted = livePoll.userVotes?.contains(index.toString()) ?? false;

                    return _OptionTile(
                      option: option,
                      percentage: percentage,
                      voteCount: voteCount,
                      hasVoted: hasVoted,
                      onTap: livePoll.isActive && !livePoll.hasExpired
                          ? () => _toggleVote(ref, poll.id, index.toString(), hasVoted)
                          : null,
                    );
                  }),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const Text('Error loading poll results'),
            ),
            const Gap(12),

            // Total votes
            pollDetailAsync.when(
              data: (livePoll) => Text(
                '${livePoll.totalVotes} vote${livePoll.totalVotes != 1 ? 's' : ''}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),

            // Status
            if (poll.hasExpired)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Poll has expired',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _toggleVote(WidgetRef ref, String pollId, String optionIndex, bool hasVoted) async {
    if (hasVoted) {
      await ref.read(pollDetailProvider(pollId).notifier).removeVote(optionIndex);
    } else {
      await ref.read(pollDetailProvider(pollId).notifier).vote(optionIndex);
    }
  }
}

class _OptionTile extends StatelessWidget {
  final String option;
  final double percentage;
  final int voteCount;
  final bool hasVoted;
  final VoidCallback? onTap;

  const _OptionTile({
    required this.option,
    required this.percentage,
    required this.voteCount,
    required this.hasVoted,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: hasVoted ? Theme.of(context).primaryColor : Colors.grey[300]!,
            width: hasVoted ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(option)),
                Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontWeight: hasVoted ? FontWeight.bold : FontWeight.normal,
                    color: hasVoted ? Theme.of(context).primaryColor : null,
                  ),
                ),
              ],
            ),
            const Gap(4),
            LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation(
                hasVoted ? Theme.of(context).primaryColor : Colors.grey[400],
              ),
            ),
            const Gap(4),
            Text(
              '$voteCount vote${voteCount != 1 ? 's' : ''}',
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
