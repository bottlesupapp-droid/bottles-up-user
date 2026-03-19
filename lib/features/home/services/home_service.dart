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
      print('Error fetching categories: $e');
      // Return only the "All" category if there's an error
      return [const Category(id: 'all', name: 'All', icon: 'all')];
    }
  }

  /// Fetch clubs with their categories from Supabase
  Future<List<Club>> getClubs({String? categoryId}) async {
    try {
      print('Fetching clubs - categoryId: $categoryId');
      
      // Use clubs_with_categories directly since we know it exists
      var query = _supabase
          .from('clubs_with_categories')
          .select()
          .eq('is_active', true);
      
      if (categoryId != null && categoryId != 'all') {
        query = query.eq('category_id', categoryId);
      }
      
      final response = await query.order('avg_rating', ascending: false);
      print('Raw response: $response');

      final clubs = response.map((data) => Club.fromSupabase(data)).toList();
      print('Parsed clubs: ${clubs.length} clubs');
      
      return clubs;
    } catch (e, stackTrace) {
      print('Error fetching clubs: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }

  /// Fetch featured clubs (highest rated or marked as featured)
  Future<List<Club>> getFeaturedClubs() async {
    try {
      print('Fetching featured clubs...');
      
      // Use clubs_with_categories directly and get clubs with rating >= 4.0
      final response = await _supabase
          .from('clubs_with_categories')
          .select()
          .eq('is_active', true)
          .gte('avg_rating', 4.0)
          .order('avg_rating', ascending: false)
          .limit(5);

      print('Featured clubs raw response: $response');

      final clubs = response.map((data) => Club.fromSupabase(data)).toList();
      print('Featured clubs parsed: ${clubs.length} clubs');
      
      return clubs;
    } catch (e, stackTrace) {
      print('Error fetching featured clubs: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }

  /// Fetch clubs with pagination (lazy loading)
  Future<List<Club>> getClubsPaginated({String? categoryId, int page = 0, int pageSize = 10}) async {
    try {
      print('Fetching clubs - categoryId: $categoryId, page: $page, pageSize: $pageSize');
      
      // Build query step by step to ensure proper chaining
      var query = _supabase
          .from('clubs_with_categories')
          .select()
          .eq('is_active', true);

      if (categoryId != null && categoryId != 'all') {
        query = query.eq('category_id', categoryId) ;
      }

      final response = await query
          .order('avg_rating', ascending: false)
          .limit(pageSize);
          
      print('Raw response: $response');
      
      final clubs = response.map((data) => Club.fromSupabase(data)).toList();
      print('Parsed clubs: ${clubs.length} clubs');
      
      return clubs;
    } catch (e, stackTrace) {
      print('Error fetching paginated clubs: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }
}