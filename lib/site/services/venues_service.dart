import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/venue.dart';
import '../site_error.dart';

/// Venues, their tables, booking times, floor plans and bottle menus, read from the website's tables (everything here is public: the database shows only published venues), plus the
/// website's two public functions for a table booking: which tables are taken, and the venue's refund terms.
class VenuesService {
  VenuesService(this._db);

  final SupabaseClient _db;

  static const String _venueColumns = 'id, name, slug, description, address, cover_image_url, gallery, category, phone, website_url, hours_note, dress_code, capacity, music_genres, '
      'tax_rate_bps, show_bottle_images, bottle_payment_mode, deposit_is_credit, booking_start_date, booking_end_date';
  static const String _tableColumns = 'id, venue_id, name, description, max_guests, min_guests, min_spend_cents, deposit_cents, currency, inventory_count, image_url, badge_label, is_featured, '
      'floor_id, pos_x, pos_y, width, height, pricing_mode, hourly_rate_cents, min_hours, table_view, privacy_level, seating_type, amenities, policy_note, included_admissions, sort_order';
  static const String _slotColumns = 'id, venue_id, day_of_week, start_time, label';
  static const String _select = '$_venueColumns, site_table_types($_tableColumns), site_venue_time_slots($_slotColumns)';

  /// The published venues that have at least one table, by name.
  Future<List<Venue>> venues() async {
    try {
      final rows = await _db.from('site_venues').select(_select).eq('status', 'published').order('name', ascending: true);
      return [
        for (final r in rows)
          if (parseVenue(Map<String, dynamic>.from(r)) case final v? when v.tables.isNotEmpty) v,
      ];
    } catch (error) {
      logProblem('load venues', error);
      throw SiteException(loadFailedMessage('venues'));
    }
  }

  /// One published venue, or null when it is not there (taken down, or never existed).
  Future<Venue?> venue(String id) async {
    try {
      final row = await _db.from('site_venues').select(_select).eq('id', id).eq('status', 'published').maybeSingle();
      return row == null ? null : parseVenue(Map<String, dynamic>.from(row));
    } catch (error) {
      logProblem('load venue', error);
      throw SiteException(loadFailedMessage('this venue'));
    }
  }

  Future<List<Floor>> floors(String venueId) async {
    try {
      final rows = await _db.from('site_venue_floors').select('id, venue_id, label, image_url, sort_order').eq('venue_id', venueId).order('sort_order', ascending: true);
      return [
        for (final r in rows)
          if (parseFloor(Map<String, dynamic>.from(r)) case final f?) f,
      ];
    } catch (error) {
      logProblem('load floors', error);
      throw SiteException(loadFailedMessage('the floor plan'));
    }
  }

  /// The bottles a guest can order here: available and not sold out, in the venue's own order.
  Future<List<Bottle>> bottles(String venueId) async {
    try {
      final rows = await _db
          .from('site_bottles')
          .select('id, venue_id, name, size, description, price_cents, currency, category, image_url, is_available, is_sold_out, sort_order')
          .eq('venue_id', venueId)
          .eq('is_available', true)
          .eq('is_sold_out', false)
          .order('sort_order', ascending: true);
      return [
        for (final r in rows)
          if (parseBottle(Map<String, dynamic>.from(r)) case final b?) b,
      ];
    } catch (error) {
      logProblem('load bottles', error);
      throw SiteException(loadFailedMessage('the bottle menu'));
    }
  }

  /// The ids of the tables that are full for a night and arrival time: already booked, held for someone who is paying right now, or closed by the venue. [night] is the night the guest
  /// picked (the website works out the arrival day for an after-midnight time).
  Future<Set<String>> unavailableTables({required String venueId, required String night, required String slotId}) async {
    try {
      final data = await _db.rpc('get_unavailable_table_types', params: {'p_venue_id': venueId, 'p_booking_date': night, 'p_time_slot_id': slotId});
      if (data is! List) throw const FormatException('not a list');
      return {
        for (final x in data)
          if (x is String && x.isNotEmpty) x,
      };
    } catch (error) {
      logProblem('check table availability', error);
      throw const SiteException('We could not check which tables are free. Check your connection and try again.');
    }
  }

  /// What the venue says about cancelling and refunds, in plain sentences; null when it says nothing or cannot be read (nothing is then shown, as on the website).
  Future<RefundPolicy?> refundPolicy(String venueId) async {
    try {
      final data = await _db.rpc('public_venue_refund_policy', params: {'p_venue': venueId});
      if (data is! List || data.isEmpty || data.first is! Map) return null;
      final row = Map<String, dynamic>.from(data.first as Map);
      final raw = row['lines'];
      final lines = raw is List ? [for (final l in raw) if (l is String && l.trim().isNotEmpty) l.trim()] : <String>[];
      return lines.isEmpty ? null : RefundPolicy(hasPolicy: row['has_policy'] == true, lines: lines);
    } catch (error) {
      logProblem('load refund policy', error);
      return null;
    }
  }

  /// BottlesUp's service fee in basis points (`site_content.bottlesup_fee_bps`), for showing the total before paying; null when it cannot be read.
  Future<int?> feeBasisPoints() async {
    try {
      final row = await _db.from('site_content').select('bottlesup_fee_bps').eq('id', 1).maybeSingle();
      final v = row?['bottlesup_fee_bps'];
      return v is num && v >= 0 ? v.toInt() : null;
    } catch (error) {
      logProblem('load fee', error);
      return null;
    }
  }
}
