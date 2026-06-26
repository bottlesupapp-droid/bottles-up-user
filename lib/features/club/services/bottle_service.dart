import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/bottle.dart';

class BottleService {
  static BottleService? _instance;
  static BottleService get instance => _instance ??= BottleService._();
  
  BottleService._();

  final SupabaseClient _supabase = Supabase.instance.client;

  /// Get bottles for a specific club
  Future<List<Bottle>> getBottlesForClub(String clubId) async {
    try {
      final response = await _supabase
          .from('bottles')
          .select('*')
          .eq('club_id', clubId)
          .eq('is_available', true)
          .order('is_featured', ascending: false)
          .order('category')
          .order('price');

      if (response.isEmpty) {
        return _getFallbackBottles(clubId);
      }

      return response
          .map<Bottle>((data) => Bottle.fromSupabase(data))
          .toList();
    } catch (e) {
      return _getFallbackBottles(clubId);
    }
  }

  /// Get featured bottles for a specific club
  Future<List<Bottle>> getFeaturedBottlesForClub(String clubId) async {
    try {
      final response = await _supabase
          .from('bottles')
          .select('*')
          .eq('club_id', clubId)
          .eq('is_available', true)
          .eq('is_featured', true)
          .order('price', ascending: false)
          .limit(6);

      final bottles = response
          .map<Bottle>((data) => Bottle.fromSupabase(data))
          .toList();

      // If no featured bottles, get the most expensive ones
      if (bottles.isEmpty) {
        final expensiveBottles = await _supabase
            .from('bottles')
            .select('*')
            .eq('club_id', clubId)
            .eq('is_available', true)
            .order('price', ascending: false)
            .limit(6);

        return expensiveBottles
            .map<Bottle>((data) => Bottle.fromSupabase(data))
            .toList();
      }

      return bottles;
    } catch (e) {
      return _getFallbackBottles(clubId).take(6).toList();
    }
  }

  /// Get bottles by category for a specific club
  Future<List<Bottle>> getBottlesByCategory(String clubId, String category) async {
    try {
      final response = await _supabase
          .from('bottles')
          .select('*')
          .eq('club_id', clubId)
          .eq('category', category)
          .eq('is_available', true)
          .order('price');

      return response
          .map<Bottle>((data) => Bottle.fromSupabase(data))
          .toList();
    } catch (e) {
      return _getFallbackBottles(clubId)
          .where((bottle) => bottle.category.toLowerCase() == category.toLowerCase())
          .toList();
    }
  }

  /// Get available categories for a specific club
  Future<List<String>> getCategoriesForClub(String clubId) async {
    try {
      final response = await _supabase
          .from('bottles')
          .select('category')
          .eq('club_id', clubId)
          .eq('is_available', true);

      final categories = response
          .map<String>((data) => data['category'] as String)
          .toSet()
          .toList();

      categories.sort();
      return categories;
    } catch (e) {
      return ['champagne', 'spirits', 'wine', 'beer', 'cocktail'];
    }
  }

  /// Fallback bottles data when Supabase is unavailable
  List<Bottle> _getFallbackBottles(String clubId) {
    return [
      Bottle(
        id: 'bottle-1',
        clubId: clubId,
        name: 'Dom Pérignon',
        category: 'champagne',
        brand: 'Dom Pérignon',
        price: 299.0,
        volumeMl: 750,
        alcoholContent: 12.5,
        description: 'Premium champagne with exceptional quality',
        imageUrl: 'https://images.unsplash.com/photo-1558618047-3c8c76ca7d13?w=300&h=400&fit=crop',
        isFeatured: true,
      ),
      Bottle(
        id: 'bottle-2',
        clubId: clubId,
        name: 'Hennessy XO',
        category: 'spirits',
        subcategory: 'cognac',
        brand: 'Hennessy',
        price: 199.0,
        volumeMl: 700,
        alcoholContent: 40.0,
        description: 'Premium cognac with rich flavors',
        imageUrl: 'https://images.unsplash.com/photo-1569529465841-dfecdab7503b?w=300&h=400&fit=crop',
        isFeatured: true,
      ),
      Bottle(
        id: 'bottle-3',
        clubId: clubId,
        name: 'Grey Goose',
        category: 'spirits',
        subcategory: 'vodka',
        brand: 'Grey Goose',
        price: 89.0,
        volumeMl: 750,
        alcoholContent: 40.0,
        description: 'Ultra-premium vodka from France',
        imageUrl: 'https://images.unsplash.com/photo-1545171882-7bf4b3c4e4c3?w=300&h=400&fit=crop',
      ),
      Bottle(
        id: 'bottle-4',
        clubId: clubId,
        name: 'Macallan 18',
        category: 'spirits',
        subcategory: 'whisky',
        brand: 'Macallan',
        price: 449.0,
        volumeMl: 700,
        alcoholContent: 43.0,
        description: 'Aged single malt Scotch whisky',
        imageUrl: 'https://images.unsplash.com/photo-1569529465841-dfecdab7503b?w=300&h=400&fit=crop',
        isFeatured: true,
      ),
      Bottle(
        id: 'bottle-5',
        clubId: clubId,
        name: 'Cristal',
        category: 'champagne',
        brand: 'Louis Roederer',
        price: 349.0,
        volumeMl: 750,
        alcoholContent: 12.0,
        description: 'Luxury champagne with crystal clear quality',
        imageUrl: 'https://images.unsplash.com/photo-1558618047-3c8c76ca7d13?w=300&h=400&fit=crop',
        isFeatured: true,
      ),
      Bottle(
        id: 'bottle-6',
        clubId: clubId,
        name: 'Patron Silver',
        category: 'spirits',
        subcategory: 'tequila',
        brand: 'Patron',
        price: 79.0,
        volumeMl: 750,
        alcoholContent: 40.0,
        description: 'Premium silver tequila from Mexico',
        imageUrl: 'https://images.unsplash.com/photo-1545171882-7bf4b3c4e4c3?w=300&h=400&fit=crop',
      ),
    ];
  }
} 