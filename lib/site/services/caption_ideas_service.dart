import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/post.dart';
import '../rules/caption_rules.dart';
import '../site_error.dart';

/// What the caption writer gave back: up to three captions, or none and a sentence to show instead.
class CaptionIdeas {
  const CaptionIdeas({required this.captions, this.message});

  final List<String> captions;
  final String? message;
}

/// Caption ideas, through the website's `suggest-caption`. The website checks the person may ask (the feature is on, the rules are accepted, today's limit), and sends only the
/// words typed (and the name of a tagged place or event) to the AI. Nothing is posted: the person reads the ideas and chooses.
class CaptionIdeasService {
  CaptionIdeasService(this._db);

  final SupabaseClient _db;

  Future<CaptionIdeas> suggest({required String idea, required PostKind kind, String? context}) async {
    try {
      final response = await _db.functions.invoke('suggest-caption', body: {
        'idea': idea.replaceAll(RegExp(r'\s+'), ' ').trim(),
        'kind': kind.name,
        if (context != null && context.trim().isNotEmpty) 'context': context.trim(),
      });
      final data = response.data;
      if (data is! Map) throw const FormatException('not an object');
      final captions = [
        if (data['captions'] is List)
          for (final c in data['captions'] as List)
            if (c is String && c.trim().isNotEmpty) c.trim(),
      ].take(ideasMax).toList();
      final message = data['message'];
      return CaptionIdeas(captions: captions, message: message is String && message.trim().isNotEmpty ? message.trim() : null);
    } catch (error) {
      throw siteExceptionFrom(error, generic: 'We could not get caption ideas. Check your connection and try again.');
    }
  }
}
