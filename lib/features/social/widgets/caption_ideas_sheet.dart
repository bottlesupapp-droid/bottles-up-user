import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../site/models/post.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/caption_rules.dart';
import '../../../site/services/caption_ideas_service.dart';
import '../../../site/site_error.dart';
import 'rules_gate.dart';

/// Asks what the post is about and offers up to three caption ideas written by an AI. Answers the one the person chose (to put in the caption box, where they can change it), or
/// null when they closed it. [context] is the name of a tagged place or event, [start] the words already typed in the caption box.
Future<String?> showCaptionIdeasSheet(BuildContext context, {required PostKind kind, String? placeOrEvent, String start = ''}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _CaptionIdeasSheet(kind: kind, placeOrEvent: placeOrEvent, start: start),
  );
}

class _CaptionIdeasSheet extends ConsumerStatefulWidget {
  const _CaptionIdeasSheet({required this.kind, this.placeOrEvent, this.start = ''});

  final PostKind kind;
  final String? placeOrEvent;
  final String start;

  @override
  ConsumerState<_CaptionIdeasSheet> createState() => _CaptionIdeasSheetState();
}

class _CaptionIdeasSheetState extends ConsumerState<_CaptionIdeasSheet> {
  late final _idea = TextEditingController(text: widget.start.length > ideaMax ? widget.start.substring(0, ideaMax) : widget.start);
  CaptionIdeas? _ideas;
  bool _busy = false;
  String? _problem;

  @override
  void dispose() {
    _idea.dispose();
    super.dispose();
  }

  Future<void> _ask() async {
    if (!await ensureRulesAccepted(context, ref)) return;
    setState(() {
      _busy = true;
      _problem = null;
    });
    try {
      final ideas = await ref.read(captionIdeasServiceProvider).suggest(idea: _idea.text, kind: widget.kind, context: widget.placeOrEvent);
      if (mounted) setState(() => _ideas = ideas);
    } on SiteException catch (e) {
      if (mounted) setState(() => _problem = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ideas = _ideas;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(key: const Key('caption-ideas-sheet'), mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Caption ideas', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              const Text(aiNote, key: Key('ai-note')),
              const SizedBox(height: 12),
              TextField(
                key: const Key('idea-field'),
                controller: _idea,
                maxLength: ideaMax,
                minLines: 1,
                maxLines: 4,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(labelText: 'What is it about?', hintText: widget.placeOrEvent == null ? 'Friday night with the crew' : 'Friday night with the crew at ${widget.placeOrEvent}'),
              ),
              if (_problem != null) Padding(padding: const EdgeInsets.only(top: 4), child: Text(_problem!, key: const Key('ideas-problem'), style: TextStyle(color: theme.colorScheme.error))),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  key: const Key('get-ideas'),
                  onPressed: _busy || !ideaIsEnough(_idea.text) ? null : _ask,
                  icon: const Icon(Icons.auto_awesome),
                  label: Text(_busy ? 'Thinking...' : (ideas == null ? 'Get ideas' : 'Try again')),
                ),
              ),
              if (ideas != null && ideas.captions.isEmpty) Padding(padding: const EdgeInsets.only(top: 12), child: Text(ideas.message ?? 'No ideas this time. Try saying it a different way.', key: const Key('no-ideas'))),
              if (ideas != null)
                for (var i = 0; i < ideas.captions.length; i++)
                  Card(
                    key: Key('idea-$i'),
                    margin: const EdgeInsets.only(top: 8),
                    child: ListTile(
                      title: Text(ideas.captions[i]),
                      trailing: TextButton(key: Key('use-idea-$i'), onPressed: () => Navigator.of(context).pop(ideas.captions[i]), child: const Text('Use')),
                      onTap: () => Navigator.of(context).pop(ideas.captions[i]),
                    ),
                  ),
            ]),
          ),
        ),
      ),
    );
  }
}
