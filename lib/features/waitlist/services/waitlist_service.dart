import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/waitlist.dart';

class WaitlistService {
  static final WaitlistService _instance = WaitlistService._internal();
  factory WaitlistService() => _instance;
  WaitlistService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Join waitlist
  Future<WaitlistEntry> joinWaitlist({
    required String eventId,
    required int partySize,
    String? notes,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Check if already on waitlist
      final existing = await _supabase
          .from('waitlist')
          .select()
          .eq('user_id', currentUser.id)
          .eq('event_id', eventId)
          .eq('status', WaitlistStatus.active.name)
          .maybeSingle();

      if (existing != null) {
        return WaitlistEntry.fromSupabase(existing);
      }

      // Get current position
      final currentCount = await _supabase
          .from('waitlist')
          .select('id')
          .eq('event_id', eventId)
          .eq('status', WaitlistStatus.active.name);

      final position = (currentCount as List).length + 1;

      // Set expiration time (24 hours from now)
      final expiresAt = DateTime.now().add(const Duration(hours: 24));

      final entryData = {
        'user_id': currentUser.id,
        'event_id': eventId,
        'position': position,
        'party_size': partySize,
        'user_name': currentUser.userMetadata?['full_name'],
        'user_email': currentUser.email,
        'user_phone': currentUser.userMetadata?['phone'],
        'status': WaitlistStatus.active.name,
        'notes': notes,
        'expires_at': expiresAt.toIso8601String(),
      };

      final response = await _supabase
          .from('waitlist')
          .insert(entryData)
          .select()
          .single();

      return WaitlistEntry.fromSupabase(response);
    } catch (e) {
      throw Exception('Failed to join waitlist: $e');
    }
  }

  // Leave waitlist
  Future<void> leaveWaitlist(String entryId) async {
    try {
      await _supabase
          .from('waitlist')
          .update({'status': WaitlistStatus.cancelled.name})
          .eq('id', entryId);

      // Reorder positions
      final entry = await getWaitlistEntry(entryId);
      await _reorderPositions(entry.eventId, entry.position);
    } catch (e) {
      throw Exception('Failed to leave waitlist: $e');
    }
  }

  // Get user's waitlist entries
  Future<List<WaitlistEntry>> getUserWaitlistEntries() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase
          .from('waitlist')
          .select('''
            *,
            events:event_id (
              name,
              event_date
            )
          ''')
          .eq('user_id', currentUser.id)
          .inFilter('status', [
            WaitlistStatus.active.name,
            WaitlistStatus.converted.name,
          ])
          .order('created_at', ascending: false);

      return (response as List).map((data) {
        if (data['events'] != null) {
          data['event_name'] = data['events']['name'];
          data['event_date'] = data['events']['event_date'];
        }
        return WaitlistEntry.fromSupabase(data);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  // Get event waitlist
  Future<List<WaitlistEntry>> getEventWaitlist(String eventId) async {
    try {
      final response = await _supabase
          .from('waitlist')
          .select()
          .eq('event_id', eventId)
          .eq('status', WaitlistStatus.active.name)
          .order('position', ascending: true);

      return (response as List)
          .map((data) => WaitlistEntry.fromSupabase(data))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get waitlist entry
  Future<WaitlistEntry> getWaitlistEntry(String entryId) async {
    try {
      final response = await _supabase
          .from('waitlist')
          .select()
          .eq('id', entryId)
          .single();

      return WaitlistEntry.fromSupabase(response);
    } catch (e) {
      throw Exception('Failed to get waitlist entry: $e');
    }
  }

  // Check waitlist position
  Future<int> getWaitlistPosition(String eventId) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return -1;

      final entry = await _supabase
          .from('waitlist')
          .select('position')
          .eq('user_id', currentUser.id)
          .eq('event_id', eventId)
          .eq('status', WaitlistStatus.active.name)
          .maybeSingle();

      return entry?['position'] as int? ?? -1;
    } catch (e) {
      return -1;
    }
  }

  // Notify next in line
  Future<void> notifyNextInLine(String eventId) async {
    try {
      final nextEntry = await _supabase
          .from('waitlist')
          .select()
          .eq('event_id', eventId)
          .eq('status', WaitlistStatus.active.name)
          .order('position', ascending: true)
          .limit(1)
          .maybeSingle();

      if (nextEntry != null) {
        // Update notified_at
        await _supabase
            .from('waitlist')
            .update({'notified_at': DateTime.now().toIso8601String()})
            .eq('id', nextEntry['id']);

        // Send notification (handled by backend trigger)
        await _supabase.rpc('notify_waitlist_user', params: {
          'entry_id': nextEntry['id'],
        });
      }
    } catch (e) {
      throw Exception('Failed to notify user: $e');
    }
  }

  // Convert waitlist to booking
  Future<void> convertToBooking(String entryId, String bookingId) async {
    try {
      await _supabase
          .from('waitlist')
          .update({
            'status': WaitlistStatus.converted.name,
            'booking_id': bookingId,
          })
          .eq('id', entryId);

      // Reorder remaining positions
      final entry = await getWaitlistEntry(entryId);
      await _reorderPositions(entry.eventId, entry.position);
    } catch (e) {
      throw Exception('Failed to convert waitlist entry: $e');
    }
  }

  // Auto-expire old entries
  Future<void> expireOldEntries() async {
    try {
      await _supabase
          .from('waitlist')
          .update({'status': WaitlistStatus.expired.name})
          .eq('status', WaitlistStatus.active.name)
          .lt('expires_at', DateTime.now().toIso8601String());
    } catch (e) {
      // Silently fail
    }
  }

  // Get waitlist stats
  Future<WaitlistStats> getWaitlistStats(String eventId) async {
    try {
      final entries = await getEventWaitlist(eventId);

      // Calculate average wait time
      final convertedEntries = await _supabase
          .from('waitlist')
          .select()
          .eq('event_id', eventId)
          .eq('status', WaitlistStatus.converted.name);

      int totalWaitTime = 0;
      int conversionCount = 0;

      for (final entry in (convertedEntries as List)) {
        final created = DateTime.parse(entry['created_at']);
        final notified = entry['notified_at'] != null
            ? DateTime.parse(entry['notified_at'])
            : null;

        if (notified != null) {
          totalWaitTime += notified.difference(created).inMinutes;
          conversionCount++;
        }
      }

      final averageWaitTime = conversionCount > 0
          ? (totalWaitTime / conversionCount).round()
          : 0;

      final totalEntries = entries.length + conversionCount;
      final conversionRate = totalEntries > 0
          ? ((conversionCount / totalEntries) * 100).round()
          : 0;

      return WaitlistStats(
        eventId: eventId,
        totalWaiting: entries.length,
        averageWaitTime: averageWaitTime,
        conversionRate: conversionRate,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to get stats: $e');
    }
  }

  // Helper: Reorder positions
  Future<void> _reorderPositions(String eventId, int removedPosition) async {
    try {
      // Get all entries after removed position
      final entries = await _supabase
          .from('waitlist')
          .select()
          .eq('event_id', eventId)
          .eq('status', WaitlistStatus.active.name)
          .gt('position', removedPosition)
          .order('position', ascending: true);

      // Update positions
      for (final entry in (entries as List)) {
        await _supabase
            .from('waitlist')
            .update({'position': entry['position'] - 1})
            .eq('id', entry['id']);
      }
    } catch (e) {
      // Silently fail
    }
  }

  // Subscribe to waitlist updates
  RealtimeChannel subscribeToWaitlist(
    String eventId,
    void Function(WaitlistEntry) onUpdate,
  ) {
    return _supabase
        .channel('waitlist_$eventId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'waitlist',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'event_id',
            value: eventId,
          ),
          callback: (payload) {
            if (payload.newRecord != null) {
              onUpdate(WaitlistEntry.fromSupabase(payload.newRecord));
            }
          },
        )
        .subscribe();
  }
}
