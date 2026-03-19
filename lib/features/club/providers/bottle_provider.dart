import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/bottle.dart';
import '../services/bottle_service.dart';

// Service provider
final bottleServiceProvider = Provider<BottleService>((ref) {
  return BottleService.instance;
});

// Provider for bottles by club ID
final bottlesProvider = FutureProvider.family<List<Bottle>, String>((ref, clubId) async {
  final service = ref.read(bottleServiceProvider);
  return service.getBottlesForClub(clubId);
});

// Provider for featured bottles by club ID
final featuredBottlesProvider = FutureProvider.family<List<Bottle>, String>((ref, clubId) async {
  final service = ref.read(bottleServiceProvider);
  return service.getFeaturedBottlesForClub(clubId);
});

// Provider for bottle categories by club ID
final bottleCategoriesProvider = FutureProvider.family<List<String>, String>((ref, clubId) async {
  final service = ref.read(bottleServiceProvider);
  return service.getCategoriesForClub(clubId);
});

// State provider for selected bottle category
final selectedBottleCategoryProvider = StateProvider.family<String?, String>((ref, clubId) => null);

// Provider for bottles by category
final bottlesByCategoryProvider = FutureProvider.family<List<Bottle>, ({String clubId, String? category})>((ref, params) async {
  final service = ref.read(bottleServiceProvider);
  
  if (params.category == null || params.category == 'All') {
    return service.getBottlesForClub(params.clubId);
  }
  
  return service.getBottlesByCategory(params.clubId, params.category!);
});

// Provider to refresh bottle data
final refreshBottleDataProvider = Provider.family<void, String>((ref, clubId) {
  ref.invalidate(bottlesProvider(clubId));
  ref.invalidate(featuredBottlesProvider(clubId));
  ref.invalidate(bottleCategoriesProvider(clubId));
  ref.invalidate(selectedBottleCategoryProvider(clubId));
}); 