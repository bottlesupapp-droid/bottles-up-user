import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/favorite.dart';

class FavoriteService {
  static final FavoriteService _instance = FavoriteService._internal();
  factory FavoriteService() => _instance;
  FavoriteService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Add to favorites
  Future<Favorite> addFavorite({
    required FavoriteType type,
    required String itemId,
    String? itemName,
    String? itemImage,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase.from('favorites').insert({
        'user_id': currentUser.id,
        'type': type.name,
        'item_id': itemId,
        'item_name': itemName,
        'item_image': itemImage,
        'metadata': metadata,
      }).select().single();

      return Favorite.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to add favorite: $e');
    }
  }

  // Remove from favorites
  Future<void> removeFavorite(String favoriteId) async {
    try {
      await _supabase.from('favorites').delete().eq('id', favoriteId);
    } catch (e) {
      throw Exception('Failed to remove favorite: $e');
    }
  }

  // Remove by item ID
  Future<void> removeFavoriteByItem({
    required FavoriteType type,
    required String itemId,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return;

      await _supabase
          .from('favorites')
          .delete()
          .eq('user_id', currentUser.id)
          .eq('type', type.name)
          .eq('item_id', itemId);
    } catch (e) {
      throw Exception('Failed to remove favorite: $e');
    }
  }

  // Check if item is favorited
  Future<bool> isFavorited({
    required FavoriteType type,
    required String itemId,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return false;

      final response = await _supabase
          .from('favorites')
          .select('id')
          .eq('user_id', currentUser.id)
          .eq('type', type.name)
          .eq('item_id', itemId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      return false;
    }
  }

  // Get all user favorites
  Future<List<Favorite>> getUserFavorites({FavoriteType? type}) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return [];

      var query = _supabase
          .from('favorites')
          .select()
          .eq('user_id', currentUser.id);

      if (type != null) {
        query = query.eq('type', type.name);
      }

      final response = await query.order('created_at', ascending: false);

      return (response as List)
          .map((item) => Favorite.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get favorite events
  Future<List<Map<String, dynamic>>> getFavoriteEvents() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return [];

      final response = await _supabase.rpc('get_favorite_events', params: {
        'user_id_param': currentUser.id,
      });

      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      return [];
    }
  }

  // Toggle favorite
  Future<bool> toggleFavorite({
    required FavoriteType type,
    required String itemId,
    String? itemName,
    String? itemImage,
  }) async {
    final isFav = await isFavorited(type: type, itemId: itemId);

    if (isFav) {
      await removeFavoriteByItem(type: type, itemId: itemId);
      return false;
    } else {
      await addFavorite(
        type: type,
        itemId: itemId,
        itemName: itemName,
        itemImage: itemImage,
      );
      return true;
    }
  }
}
