import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/post.dart';
import '../../../site/models/safety.dart';
import '../../../site/models/social_profile.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/post_rules.dart';
import '../../../site/site_error.dart';
import '../widgets/post_widgets.dart';
import '../widgets/profile_widgets.dart';
import '../widgets/report_sheet.dart';
import '../widgets/rules_gate.dart';

const int _commentPage = 30;

/// A post on its own, with its comments below and a box to add one. A post the person may not see is reported in one plain sentence, whatever the reason.
class PostScreen extends ConsumerWidget {
  const PostScreen({super.key, required this.postId});

  final String postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ActorGate(
      title: 'Post',
      builder: (context, actor) {
        final key = PostKey(actor: actor.id, id: postId);
        final post = ref.watch(postProvider(key));
        return post.when(
          loading: () => Scaffold(appBar: AppBar(title: const Text('Post')), body: const Center(child: CircularProgressIndicator())),
          error: (e, _) => Scaffold(
            appBar: AppBar(title: const Text('Post')),
            body: e is SiteException && e.message.contains('isn\'t available')
                ? const EmptyState(icon: Icons.visibility_off_outlined, title: 'This post isn\'t available', text: 'It may have been deleted, or you may not be able to see it.')
                : LoadFailed(message: e is SiteException ? e.message : loadFailedMessage('that post'), onRetry: () => ref.invalidate(postProvider(key))),
          ),
          data: (p) => _PostBody(actor: actor, post: p),
        );
      },
    );
  }
}

class _PostBody extends ConsumerStatefulWidget {
  const _PostBody({required this.actor, required this.post});

  final SocialProfile actor;
  final SocialPost post;

  @override
  ConsumerState<_PostBody> createState() => _PostBodyState();
}

class _PostBodyState extends ConsumerState<_PostBody> {
  final List<PostComment> _comments = [];
  final Map<String, List<PostComment>> _replies = {};
  final _input = TextEditingController();
  bool _loading = true;
  bool _more = false;
  bool _sending = false;
  String? _error;
  String? _problem;
  PostComment? _replyingTo;

  @override
  void initState() {
    super.initState();
    if (widget.post.commentsEnabled) {
      _load();
    } else {
      _loading = false;
    }
  }

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  Future<void> _load({bool next = false}) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final page = await ref.read(postsServiceProvider).comments(actor: widget.actor.id, post: widget.post.id, limit: _commentPage, after: next && _comments.isNotEmpty ? _comments.last.createdAt : null);
      if (!mounted) return;
      setState(() {
        if (!next) _comments.clear();
        _comments.addAll(page);
        _more = page.length >= _commentPage;
      });
    } on SiteException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _showReplies(PostComment c) async {
    try {
      final r = await ref.read(postsServiceProvider).comments(actor: widget.actor.id, post: widget.post.id, parent: c.id, limit: 50);
      if (mounted) setState(() => _replies[c.id] = r);
    } on SiteException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> _send() async {
    final problem = commentProblem(_input.text);
    if (problem != null) {
      setState(() => _problem = problem);
      return;
    }
    if (!await ensureRulesAccepted(context, ref)) return;
    setState(() {
      _sending = true;
      _problem = null;
    });
    try {
      final reply = _replyingTo;
      final c = await ref.read(postsServiceProvider).addComment(actor: widget.actor.id, post: widget.post.id, body: _input.text, replyTo: reply?.id);
      if (!mounted) return;
      setState(() {
        _input.clear();
        _replyingTo = null;
        if (reply == null) {
          _comments.add(c);
        } else {
          _replies[reply.id] = [...?_replies[reply.id], c];
          final i = _comments.indexWhere((x) => x.id == reply.id);
          if (i >= 0) {
            final o = _comments[i];
            _comments[i] = PostComment(id: o.id, postId: o.postId, author: o.author, body: o.body, createdAt: o.createdAt, replyTo: o.replyTo, replies: o.replies + 1, isMine: o.isMine, canDelete: o.canDelete);
          }
        }
      });
    } on SiteException catch (e) {
      if (mounted) setState(() => _problem = e.message);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _delete(PostComment c, {String? parent}) async {
    try {
      await ref.read(postsServiceProvider).deleteComment(actor: widget.actor.id, comment: c.id);
      if (!mounted) return;
      setState(() {
        if (parent == null) {
          _comments.removeWhere((x) => x.id == c.id);
          _replies.remove(c.id);
        } else {
          _replies[parent]?.removeWhere((x) => x.id == c.id);
        }
      });
    } on SiteException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Widget _tile(PostComment c, {String? parent}) {
    final theme = Theme.of(context);
    return Padding(
      key: Key('comment-${c.id}'),
      padding: EdgeInsets.fromLTRB(parent == null ? 14 : 54, 6, 8, 6),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        GestureDetector(onTap: () => context.push('/u/${c.author.handle}'), child: ProfileAvatar(profile: c.author, size: parent == null ? 32 : 26)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text.rich(TextSpan(children: [TextSpan(text: '${c.author.handle} ', style: const TextStyle(fontWeight: FontWeight.w700)), TextSpan(text: c.body)])),
            Row(children: [
              Text(timeAgo(c.createdAt, DateTime.now()), style: theme.textTheme.bodySmall),
              if (parent == null && widget.post.commentsEnabled)
                TextButton(
                  key: Key('reply-${c.id}'),
                  style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8), minimumSize: const Size(0, 28)),
                  onPressed: () => setState(() => _replyingTo = c),
                  child: const Text('Reply'),
                ),
              if (parent == null && c.replies > 0 && _replies[c.id] == null)
                TextButton(
                  key: Key('replies-${c.id}'),
                  style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8), minimumSize: const Size(0, 28)),
                  onPressed: () => _showReplies(c),
                  child: Text(c.replies == 1 ? 'View 1 reply' : 'View ${c.replies} replies'),
                ),
            ]),
            if (parent == null) for (final r in _replies[c.id] ?? const <PostComment>[]) _tile(r, parent: c.id),
          ]),
        ),
        if (!c.isMine && c.author.id != widget.actor.id)
          PopupMenuButton<String>(
            key: Key('comment-menu-${c.id}'),
            padding: EdgeInsets.zero,
            iconSize: 20,
            onSelected: (_) async {
              final result = await showReportSheet(context, actor: widget.actor, kind: ReportKind.comment, target: c.id, alsoBlock: c.author);
              if (result != null && result.blocked) _load();
            },
            itemBuilder: (_) => const [PopupMenuItem(value: 'report', child: Text('Report'))],
          ),
        if (c.canDelete) IconButton(key: Key('delete-comment-${c.id}'), tooltip: 'Delete comment', visualDensity: VisualDensity.compact, icon: const Icon(Icons.delete_outline, size: 20), onPressed: () => _delete(c, parent: parent)),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.post;
    return Scaffold(
      appBar: AppBar(title: Text(kindLabel(p.kind))),
      body: Column(children: [
        Expanded(
          child: ListView(
            key: const Key('post-page'),
            padding: const EdgeInsets.only(bottom: 16),
            children: [
              PostCardView(
                actor: widget.actor,
                post: p,
                showAllComments: true,
                onDeleted: () => context.canPop() ? context.pop() : context.go('/'),
              ),
              if (!p.commentsEnabled)
                const Padding(padding: EdgeInsets.all(16), child: Text('Comments are turned off for this post.', key: Key('comments-off')))
              else ...[
                if (_error != null) LoadFailed(message: _error!, onRetry: _load),
                if (_loading && _comments.isEmpty) const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator())),
                if (!_loading && _error == null && _comments.isEmpty) const Padding(padding: EdgeInsets.all(24), child: Center(child: Text('No comments yet. Be the first.', key: Key('no-comments')))),
                for (final c in _comments) _tile(c),
                if (_more) Padding(padding: const EdgeInsets.all(8), child: TextButton(key: const Key('more-comments'), onPressed: _loading ? null : () => _load(next: true), child: const Text('Show more comments'))),
              ],
            ],
          ),
        ),
        if (p.commentsEnabled)
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 8, 8),
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                if (_replyingTo != null)
                  Row(children: [
                    Expanded(child: Text('Replying to @${_replyingTo!.author.handle}', key: const Key('replying-to'), style: Theme.of(context).textTheme.bodySmall)),
                    IconButton(key: const Key('cancel-reply'), visualDensity: VisualDensity.compact, icon: const Icon(Icons.close, size: 18), onPressed: () => setState(() => _replyingTo = null)),
                  ]),
                if (_problem != null) Text(_problem!, key: const Key('comment-problem'), style: TextStyle(color: Theme.of(context).colorScheme.error)),
                Row(children: [
                  Expanded(child: TextField(key: const Key('comment-field'), controller: _input, minLines: 1, maxLines: 4, maxLength: maxCommentLength, decoration: const InputDecoration(hintText: 'Add a comment', counterText: ''), textCapitalization: TextCapitalization.sentences)),
                  IconButton(key: const Key('send-comment'), tooltip: 'Send', onPressed: _sending ? null : _send, icon: const Icon(Icons.send)),
                ]),
              ]),
            ),
          ),
      ]),
    );
  }
}
