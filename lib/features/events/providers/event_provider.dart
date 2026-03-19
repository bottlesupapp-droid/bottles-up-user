import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/event.dart';
import '../services/event_service.dart';

part 'event_provider.g.dart';

/// Provider for event service
@riverpod
EventService eventService(EventServiceRef ref) {
  return EventService();
}

/// Provider for fetching all events
@riverpod
Future<List<Event>> events(EventsRef ref) async {
  final service = ref.watch(eventServiceProvider);
  return await service.getUpcomingEvents(limit: 50);
}

/// Provider for fetching featured events
@riverpod
Future<List<Event>> featuredEvents(FeaturedEventsRef ref) async {
  final service = ref.watch(eventServiceProvider);
  return await service.getFeaturedEvents();
}

/// Provider for fetching a single event by ID
@riverpod
Future<Event> eventById(EventByIdRef ref, String eventId) async {
  final service = ref.watch(eventServiceProvider);
  return await service.getEventById(eventId);
}

/// Provider for searching events
@riverpod
class EventSearch extends _$EventSearch {
  @override
  Future<List<Event>> build() async {
    return [];
  }

  Future<void> search({
    String? query,
    String? genre,
    String? city,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final service = ref.read(eventServiceProvider);
      return await service.getEvents(
        searchQuery: query,
        genre: genre,
        city: city,
        startDate: startDate,
        endDate: endDate,
        limit: 50,
      );
    });
  }

  void clear() {
    state = const AsyncValue.data([]);
  }
}
