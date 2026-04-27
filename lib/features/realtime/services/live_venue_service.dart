import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/realtime_models.dart';

class LiveVenueService {
  static final LiveVenueService _instance = LiveVenueService._internal();
  factory LiveVenueService() => _instance;
  LiveVenueService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;
  final Map<String, RealtimeChannel> _venueChannels = {};

  // Get current venue availability
  Future<LiveVenueAvailability?> getVenueAvailability(String venueId) async {
    try {
      final response = await _supabase
          .from('venue_availability')
          .select()
          .eq('venue_id', venueId)
          .maybeSingle();

      if (response == null) return null;

      return LiveVenueAvailability.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  // Subscribe to venue availability updates
  RealtimeChannel subscribeToVenueAvailability({
    required String venueId,
    required Function(LiveVenueAvailability) onUpdate,
  }) {
    // Unsubscribe existing channel if present
    if (_venueChannels.containsKey(venueId)) {
      _venueChannels[venueId]!.unsubscribe();
    }

    final channel = _supabase.channel('venue_availability_$venueId');

    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'venue_availability',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'venue_id',
            value: venueId,
          ),
          callback: (payload) {
            final data = payload.newRecord;
            if (data.isNotEmpty) {
              final availability = LiveVenueAvailability.fromSupabase(data);
              onUpdate(availability);
            }
          },
        )
        .subscribe();

    _venueChannels[venueId] = channel;
    return channel;
  }

  // Unsubscribe from venue updates
  void unsubscribeFromVenue(String venueId) {
    if (_venueChannels.containsKey(venueId)) {
      _venueChannels[venueId]!.unsubscribe();
      _venueChannels.remove(venueId);
    }
  }

  // Unsubscribe from all venues
  void unsubscribeAll() {
    for (final channel in _venueChannels.values) {
      channel.unsubscribe();
    }
    _venueChannels.clear();
  }

  // Get multiple venues availability
  Future<List<LiveVenueAvailability>> getMultipleVenuesAvailability(
    List<String> venueIds,
  ) async {
    try {
      final response = await _supabase
          .from('venue_availability')
          .select()
          .in_('venue_id', venueIds);

      return (response as List)
          .map((item) =>
              LiveVenueAvailability.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Subscribe to multiple venues
  void subscribeToMultipleVenues({
    required List<String> venueIds,
    required Function(String venueId, LiveVenueAvailability) onUpdate,
  }) {
    for (final venueId in venueIds) {
      subscribeToVenueAvailability(
        venueId: venueId,
        onUpdate: (availability) => onUpdate(venueId, availability),
      );
    }
  }
}

class RealtimeBookingService {
  static final RealtimeBookingService _instance = RealtimeBookingService._internal();
  factory RealtimeBookingService() => _instance;
  RealtimeBookingService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;
  RealtimeChannel? _bookingChannel;

  // Subscribe to booking updates
  RealtimeChannel subscribeToBookingUpdates({
    required Function(BookingStatusUpdate) onUpdate,
  }) {
    final currentUser = _supabase.auth.currentUser;
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }

    _bookingChannel?.unsubscribe();

    final channel = _supabase.channel('booking_updates_${currentUser.id}');

    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'booking_status_updates',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: currentUser.id,
          ),
          callback: (payload) {
            final update = BookingStatusUpdate.fromSupabase(payload.newRecord);
            onUpdate(update);
          },
        )
        .subscribe();

    _bookingChannel = channel;
    return channel;
  }

  // Subscribe to specific booking
  RealtimeChannel subscribeToBooking({
    required String bookingId,
    required Function(BookingStatusUpdate) onUpdate,
  }) {
    final channel = _supabase.channel('booking_$bookingId');

    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'booking_status_updates',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'booking_id',
            value: bookingId,
          ),
          callback: (payload) {
            final update = BookingStatusUpdate.fromSupabase(payload.newRecord);
            onUpdate(update);
          },
        )
        .subscribe();

    return channel;
  }

  void unsubscribe() {
    _bookingChannel?.unsubscribe();
    _bookingChannel = null;
  }
}

class QueueManagementService {
  static final QueueManagementService _instance = QueueManagementService._internal();
  factory QueueManagementService() => _instance;
  QueueManagementService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Join queue
  Future<QueueEntry> joinQueue({
    required String venueId,
    required int partySize,
    Map<String, dynamic>? preferences,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase.rpc('join_venue_queue', params: {
        'venue_id_param': venueId,
        'user_id_param': currentUser.id,
        'party_size_param': partySize,
        'preferences_param': preferences,
      });

      return QueueEntry.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to join queue: $e');
    }
  }

  // Get queue position
  Future<QueueEntry?> getQueuePosition(String queueEntryId) async {
    try {
      final response = await _supabase
          .from('queue_entries')
          .select()
          .eq('id', queueEntryId)
          .maybeSingle();

      if (response == null) return null;

      return QueueEntry.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  // Leave queue
  Future<void> leaveQueue(String queueEntryId) async {
    try {
      await _supabase.from('queue_entries').update({
        'status': QueueStatus.cancelled.name,
      }).eq('id', queueEntryId);
    } catch (e) {
      throw Exception('Failed to leave queue: $e');
    }
  }

  // Subscribe to queue updates
  RealtimeChannel subscribeToQueueUpdates({
    required String queueEntryId,
    required Function(QueueEntry) onUpdate,
  }) {
    final channel = _supabase.channel('queue_entry_$queueEntryId');

    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'queue_entries',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id',
            value: queueEntryId,
          ),
          callback: (payload) {
            final entry = QueueEntry.fromSupabase(payload.newRecord);
            onUpdate(entry);
          },
        )
        .subscribe();

    return channel;
  }

  // Get venue queue
  Future<List<QueueEntry>> getVenueQueue(String venueId) async {
    try {
      final response = await _supabase
          .from('queue_entries')
          .select()
          .eq('venue_id', venueId)
          .eq('status', QueueStatus.waiting.name)
          .order('position', ascending: true);

      return (response as List)
          .map((item) => QueueEntry.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }
}

class EventUpdatesService {
  static final EventUpdatesService _instance = EventUpdatesService._internal();
  factory EventUpdatesService() => _instance;
  EventUpdatesService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Subscribe to event updates
  RealtimeChannel subscribeToEventUpdates({
    required String eventId,
    required Function(EventUpdate) onUpdate,
  }) {
    final channel = _supabase.channel('event_updates_$eventId');

    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'event_updates',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'event_id',
            value: eventId,
          ),
          callback: (payload) {
            final update = EventUpdate.fromSupabase(payload.newRecord);
            onUpdate(update);
          },
        )
        .subscribe();

    return channel;
  }

  // Get event updates
  Future<List<EventUpdate>> getEventUpdates({
    required String eventId,
    int limit = 50,
  }) async {
    try {
      final response = await _supabase
          .from('event_updates')
          .select()
          .eq('event_id', eventId)
          .order('timestamp', ascending: false)
          .limit(limit);

      return (response as List)
          .map((item) => EventUpdate.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Subscribe to user's events
  RealtimeChannel subscribeToUserEvents({
    required Function(EventUpdate) onUpdate,
  }) {
    final currentUser = _supabase.auth.currentUser;
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }

    final channel = _supabase.channel('user_event_updates_${currentUser.id}');

    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'event_updates',
          callback: (payload) async {
            // Check if user is attending this event
            final eventId = payload.newRecord['event_id'] as String;
            final isAttending = await _checkUserAttendingEvent(eventId);

            if (isAttending) {
              final update = EventUpdate.fromSupabase(payload.newRecord);
              onUpdate(update);
            }
          },
        )
        .subscribe();

    return channel;
  }

  Future<bool> _checkUserAttendingEvent(String eventId) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return false;

      final response = await _supabase
          .from('event_attendees')
          .select('id')
          .eq('event_id', eventId)
          .eq('user_id', currentUser.id)
          .maybeSingle();

      return response != null;
    } catch (e) {
      return false;
    }
  }
}
