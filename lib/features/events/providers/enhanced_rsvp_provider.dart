import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/rsvp_status.dart';
import '../services/enhanced_rsvp_service.dart';

part 'enhanced_rsvp_provider.g.dart';

@riverpod
class EventRsvpCounts extends _$EventRsvpCounts {
  @override
  Future<RsvpCounts> build(String eventId) async {
    final rsvpService = EnhancedRsvpService();
    return await rsvpService.getRsvpCounts(eventId);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  // Subscribe to real-time updates
  void subscribeToUpdates() {
    final rsvpService = EnhancedRsvpService();
    rsvpService.subscribeToRsvpUpdates(eventId, (counts) {
      state = AsyncValue.data(counts);
    });
  }
}

@riverpod
class EventRsvpList extends _$EventRsvpList {
  @override
  Future<List<EnhancedEventRSVP>> build(String eventId) async {
    final rsvpService = EnhancedRsvpService();
    return await rsvpService.getEventRsvps(eventId);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

@riverpod
class MyEventRsvp extends _$MyEventRsvp {
  @override
  Future<EnhancedEventRSVP?> build(String eventId) async {
    final rsvpService = EnhancedRsvpService();
    return await rsvpService.getMyRsvp(eventId);
  }

  Future<void> submitRsvp({
    required RsvpResponse response,
    bool plusOneEnabled = false,
    String? plusOneName,
    String? specialRequests,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final rsvpService = EnhancedRsvpService();
      final rsvp = await rsvpService.submitRsvp(
        eventId: eventId,
        response: response,
        plusOneEnabled: plusOneEnabled,
        plusOneName: plusOneName,
        specialRequests: specialRequests,
      );

      // Refresh counts
      ref.invalidate(eventRsvpCountsProvider(eventId));

      return rsvp;
    });
  }
}

@riverpod
class FriendsAttendingEvent extends _$FriendsAttendingEvent {
  @override
  Future<List<FriendAttending>> build(String eventId) async {
    final authState = await ref.watch(authProvider.future);
    if (authState == null) return [];

    final rsvpService = EnhancedRsvpService();
    return await rsvpService.getFriendsAttending(eventId);
  }
}

@riverpod
class EventGuestListVisibility extends _$EventGuestListVisibility {
  @override
  Future<GuestListVisibility> build(String eventId) async {
    final rsvpService = EnhancedRsvpService();
    return await rsvpService.getGuestListVisibility(eventId);
  }

  Future<void> updateVisibility(GuestListVisibility settings) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final rsvpService = EnhancedRsvpService();
      await rsvpService.updateGuestListVisibility(
        eventId: eventId,
        settings: settings,
      );
      return settings;
    });
  }
}
