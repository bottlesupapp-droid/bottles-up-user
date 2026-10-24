import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category.dart';
import '../models/club.dart';

class HomeService {
  static final HomeService _instance = HomeService._internal();
  factory HomeService() => _instance;
  HomeService._internal();

  static HomeService get instance => _instance;

  final SupabaseClient _supabase = Supabase.instance.client;

  /// Fetch all active categories from Supabase
  Future<List<Category>> getCategories() async {
    try {
      final response = await _supabase
          .from('categories')
          .select()
          .eq('is_active', true)
          .order('name');

      final categories = response.map((data) => Category.fromSupabase(data)).toList();
      
      // Add "All" category at the beginning
      return [
        const Category(id: 'all', name: 'All', icon: 'all'),
        ...categories,
      ];
    } catch (e) {
      return [const Category(id: 'all', name: 'All', icon: 'all')];
    }
  }

  /// Fetch clubs with their categories from Supabase
  Future<List<Club>> getClubs({String? categoryId}) async {
    try {
      var query = _supabase
          .from('clubs_with_categories')
          .select()
          .eq('is_active', true);

      if (categoryId != null && categoryId != 'all') {
        query = query.eq('category_id', categoryId);
      }

      final response = await query.order('avg_rating', ascending: false);
      return response.map((data) => Club.fromSupabase(data)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Fetch featured clubs (highest rated or marked as featured)
  Future<List<Club>> getFeaturedClubs() async {
    try {
      final response = await _supabase
          .from('clubs_with_categories')
          .select()
          .eq('is_active', true)
          .order('avg_rating', ascending: false)
          .limit(5);

      return response.map((data) => Club.fromSupabase(data)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Fetch clubs with pagination (lazy loading)
  Future<List<Club>> getClubsPaginated({String? categoryId, int page = 0, int pageSize = 10}) async {
    try {
      var query = _supabase
          .from('clubs_with_categories')
          .select()
          .eq('is_active', true);

      if (categoryId != null && categoryId != 'all') {
        query = query.eq('category_id', categoryId);
      }

      final response = await query
          .order('avg_rating', ascending: false)
          .limit(pageSize);

      return response.map((data) => Club.fromSupabase(data)).toList();
    } catch (e) {
      return [];
    }
  }
}