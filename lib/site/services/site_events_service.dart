import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/site_event.dart';
import '../site_error.dart';

/// Reads the website's published events and their ticket types (`site_events`, `site_ticket_tiers`). Anyone can read these; the database lets a visitor see only published ones.
class SiteEventsService {
  SiteEventsService(this._db);

  final SupabaseClient _db;

  static const String _columns = 'id, title, description, venue_name, address, start_date, end_date, cover_image_url, banner_image_url, gallery, category, slug, venue_id, lineup, '
      'good_to_know, organizer_name, organizer_bio, organizer_verified, '
      'tiers:site_ticket_tiers(id, event_id, name, price_cents, currency, capacity, sold_count, requires_access_code, is_non_transferable)';

  /// The events that have not ended yet, soonest first. An event that cannot be read is left out rather than failing the list.
  Future<List<SiteEvent>> upcoming({DateTime? now}) async {
    final at = now ?? DateTime.now();
    try {
      final rows = await _db.from('site_events').select(_columns).eq('status', 'published').order('start_date', ascending: true);
      final events = <SiteEvent>[
        for (final r in rows)
          if (parseSiteEvent(Map<String, dynamic>.from(r)) case final e?)
            if (!e.isOver(at)) e,
      ]..sort((a, b) => a.start.compareTo(b.start));
      return events;
    } catch (error) {
      logProblem('load events', error);
      throw SiteException(loadFailedMessage('events'));
    }
  }

  /// One published event with its ticket types, or null when there is no such published event.
  Future<SiteEvent?> event(String id) async {
    try {
      final row = await _db.from('site_events').select(_columns).eq('id', id).eq('status', 'published').maybeSingle();
      return row == null ? null : parseSiteEvent(Map<String, dynamic>.from(row));
    } catch (error) {
      logProblem('load event', error);
      throw SiteException(loadFailedMessage('this event'));
    }
  }
}
