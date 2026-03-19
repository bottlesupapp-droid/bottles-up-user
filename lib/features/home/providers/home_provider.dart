import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/club.dart';
import '../models/category.dart';
import '../services/home_service.dart';
import '../services/events_service.dart';
import '../../events/models/event.dart';
import 'event_filter_provider.dart';

part 'home_provider.g.dart';

const int clubsPageSize = 10;

@riverpod
class SelectedCategory extends _$SelectedCategory {
  @override
  String build() => 'all';

  void update(String category) {
    state = category;
  }
}

@riverpod
Future<List<Category>> categories(CategoriesRef ref) async {
  return await HomeService.instance.getCategories();
}

@riverpod
Future<List<Club>> clubs(ClubsRef ref) async {
  final selectedCategory = ref.watch(selectedCategoryProvider);
  
  final clubs = await HomeService.instance.getClubsPaginated(
    categoryId: selectedCategory == 'all' ? null : selectedCategory,
    page: 0,
    pageSize: clubsPageSize,
  );
  
  return clubs;
}

@riverpod
Future<List<Club>> featuredClubs(FeaturedClubsRef ref) async {
  return await HomeService.instance.getFeaturedClubs();
}

// Events Providers
@riverpod
Future<List<Event>> upcomingEvents(UpcomingEventsRef ref) async {
  final filter = ref.watch(eventFilterStateProvider);
  return await HomeEventsService().getUpcomingEvents(
    limit: 10,
    genre: filter.genre,
    date: filter.date,
    location: filter.location,
  );
}

@riverpod
Future<List<Event>> featuredEvents(FeaturedEventsRef ref) async {
  return await HomeEventsService().getFeaturedEvents(limit: 5);
}

@riverpod
Future<List<Event>> todaysEvents(TodaysEventsRef ref) async {
  return await HomeEventsService().getTodaysEvents();
}

@riverpod
Future<List<Event>> liveEvents(LiveEventsRef ref) async {
  return await HomeEventsService().getLiveEvents();
}

@riverpod
Future<void> refreshHomeData(RefreshHomeDataRef ref) async {
  ref.invalidate(categoriesProvider);
  ref.invalidate(clubsProvider);
  ref.invalidate(featuredClubsProvider);
  ref.invalidate(upcomingEventsProvider);
  ref.invalidate(featuredEventsProvider);
  ref.invalidate(todaysEventsProvider);
  ref.invalidate(liveEventsProvider);
} 