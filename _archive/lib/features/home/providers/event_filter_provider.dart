import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/event_filter.dart';

part 'event_filter_provider.g.dart';

@riverpod
class EventFilterState extends _$EventFilterState {
  @override
  EventFilter build() => const EventFilter();

  void updateGenre(String? genre) {
    state = state.copyWith(genre: genre);
  }

  void updateDate(DateTime? date) {
    state = state.copyWith(date: date);
  }

  void updateLocation(String? location) {
    state = state.copyWith(location: location);
  }

  void clearFilters() {
    state = const EventFilter();
  }

  bool get hasActiveFilters {
    return state.genre != null || state.date != null || state.location != null;
  }
}
