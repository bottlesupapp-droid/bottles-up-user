import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../models/social_models.dart';

class PhotoService {
  static final PhotoService _instance = PhotoService._internal();
  factory PhotoService() => _instance;
  PhotoService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;
  final ImagePicker _imagePicker = ImagePicker();

  // Create album
  Future<PhotoAlbum> createAlbum({
    required String name,
    String? description,
    AlbumVisibility visibility = AlbumVisibility.friends,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase.from('photo_albums').insert({
        'user_id': currentUser.id,
        'name': name,
        'description': description,
        'visibility': visibility.name,
      }).select('*, owner:users!user_id(*)').single();

      return PhotoAlbum.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to create album: $e');
    }
  }

  // Get user albums
  Future<List<PhotoAlbum>> getUserAlbums({
    String? userId,
    int limit = 50,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      final targetUserId = userId ?? currentUser?.id;

      if (targetUserId == null) return [];

      final response = await _supabase
          .from('photo_albums')
          .select('*, owner:users!user_id(*)')
          .eq('user_id', targetUserId)
          .order('created_at', ascending: false)
          .limit(limit);

      return (response as List)
          .map((item) => PhotoAlbum.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get album
  Future<PhotoAlbum?> getAlbum(String albumId) async {
    try {
      final response = await _supabase
          .from('photo_albums')
          .select('*, owner:users!user_id(*), photos(*)')
          .eq('id', albumId)
          .maybeSingle();

      if (response == null) return null;

      return PhotoAlbum.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  // Update album
  Future<PhotoAlbum> updateAlbum({
    required String albumId,
    String? name,
    String? description,
    AlbumVisibility? visibility,
    String? coverPhotoUrl,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (description != null) updates['description'] = description;
      if (visibility != null) updates['visibility'] = visibility.name;
      if (coverPhotoUrl != null) updates['cover_photo_url'] = coverPhotoUrl;
      updates['updated_at'] = DateTime.now().toIso8601String();

      final response = await _supabase
          .from('photo_albums')
          .update(updates)
          .eq('id', albumId)
          .select('*, owner:users!user_id(*)')
          .single();

      return PhotoAlbum.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to update album: $e');
    }
  }

  // Delete album
  Future<void> deleteAlbum(String albumId) async {
    try {
      // Delete all photos in album first
      final photos = await getAlbumPhotos(albumId: albumId);
      for (final photo in photos) {
        await deletePhoto(photo.id);
      }

      // Delete album
      await _supabase.from('photo_albums').delete().eq('id', albumId);
    } catch (e) {
      throw Exception('Failed to delete album: $e');
    }
  }

  // Upload photo
  Future<Photo> uploadPhoto({
    required XFile imageFile,
    String? albumId,
    String? caption,
    List<String>? taggedUserIds,
    String? venueId,
    String? eventId,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Upload image to storage
      final fileName = 'photos/${currentUser.id}/${DateTime.now().millisecondsSinceEpoch}_${imageFile.name}';
      final bytes = await imageFile.readAsBytes();

      await _supabase.storage.from('media').uploadBinary(
            fileName,
            bytes,
            fileOptions: const FileOptions(
              contentType: 'image/jpeg',
            ),
          );

      // Get public URL
      final url = _supabase.storage.from('media').getPublicUrl(fileName);

      // Create thumbnail (placeholder - would use image processing)
      final thumbnailUrl = url; // In production, generate actual thumbnail

      // Create photo record
      final response = await _supabase.from('photos').insert({
        'user_id': currentUser.id,
        'album_id': albumId,
        'url': url,
        'thumbnail_url': thumbnailUrl,
        'caption': caption,
        'tagged_user_ids': taggedUserIds ?? [],
        'venue_id': venueId,
        'event_id': eventId,
      }).select('*, owner:users!user_id(*)').single();

      return Photo.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to upload photo: $e');
    }
  }

  // Pick and upload photo from gallery
  Future<Photo?> pickAndUploadPhoto({
    String? albumId,
    String? caption,
    List<String>? taggedUserIds,
    String? venueId,
    String? eventId,
  }) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image == null) return null;

      return await uploadPhoto(
        imageFile: image,
        albumId: albumId,
        caption: caption,
        taggedUserIds: taggedUserIds,
        venueId: venueId,
        eventId: eventId,
      );
    } catch (e) {
      throw Exception('Failed to pick and upload photo: $e');
    }
  }

  // Take and upload photo from camera
  Future<Photo?> takeAndUploadPhoto({
    String? albumId,
    String? caption,
    List<String>? taggedUserIds,
    String? venueId,
    String? eventId,
  }) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (image == null) return null;

      return await uploadPhoto(
        imageFile: image,
        albumId: albumId,
        caption: caption,
        taggedUserIds: taggedUserIds,
        venueId: venueId,
        eventId: eventId,
      );
    } catch (e) {
      throw Exception('Failed to take and upload photo: $e');
    }
  }

  // Get album photos
  Future<List<Photo>> getAlbumPhotos({
    required String albumId,
    int limit = 100,
  }) async {
    try {
      final response = await _supabase
          .from('photos')
          .select('*, owner:users!user_id(*), tagged_users:users!tagged_user_ids(*)')
          .eq('album_id', albumId)
          .order('created_at', ascending: false)
          .limit(limit);

      return (response as List)
          .map((item) => Photo.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get user photos
  Future<List<Photo>> getUserPhotos({
    String? userId,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      final targetUserId = userId ?? currentUser?.id;

      if (targetUserId == null) return [];

      final response = await _supabase
          .from('photos')
          .select('*, owner:users!user_id(*)')
          .eq('user_id', targetUserId)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return (response as List)
          .map((item) => Photo.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get photo
  Future<Photo?> getPhoto(String photoId) async {
    try {
      final response = await _supabase
          .from('photos')
          .select('*, owner:users!user_id(*), tagged_users:users!tagged_user_ids(*)')
          .eq('id', photoId)
          .maybeSingle();

      if (response == null) return null;

      return Photo.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  // Update photo
  Future<Photo> updatePhoto({
    required String photoId,
    String? caption,
    List<String>? taggedUserIds,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (caption != null) updates['caption'] = caption;
      if (taggedUserIds != null) updates['tagged_user_ids'] = taggedUserIds;

      final response = await _supabase
          .from('photos')
          .update(updates)
          .eq('id', photoId)
          .select('*, owner:users!user_id(*)')
          .single();

      return Photo.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to update photo: $e');
    }
  }

  // Delete photo
  Future<void> deletePhoto(String photoId) async {
    try {
      // Get photo to find file path
      final photo = await getPhoto(photoId);
      if (photo != null) {
        // Extract path after the bucket name from URL
        final uri = Uri.parse(photo.url);
        final segments = uri.pathSegments;
        final mediaIdx = segments.indexOf('media');
        final filePath = mediaIdx != -1
            ? segments.sublist(mediaIdx + 1).join('/')
            : segments.last;

        // Delete from storage
        await _supabase.storage.from('media').remove([filePath]);
      }

      // Delete record
      await _supabase.from('photos').delete().eq('id', photoId);
    } catch (e) {
      throw Exception('Failed to delete photo: $e');
    }
  }

  // Like photo
  Future<void> likePhoto(String photoId) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return;

      await _supabase.from('photo_likes').insert({
        'photo_id': photoId,
        'user_id': currentUser.id,
      });
    } catch (e) {
      throw Exception('Failed to like photo: $e');
    }
  }

  // Unlike photo
  Future<void> unlikePhoto(String photoId) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return;

      await _supabase
          .from('photo_likes')
          .delete()
          .eq('photo_id', photoId)
          .eq('user_id', currentUser.id);
    } catch (e) {
      throw Exception('Failed to unlike photo: $e');
    }
  }

  // Add comment to photo
  Future<Comment> addPhotoComment({
    required String photoId,
    required String content,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase.from('photo_comments').insert({
        'photo_id': photoId,
        'user_id': currentUser.id,
        'content': content,
      }).select('*, author:users!user_id(*)').single();

      return Comment.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to add comment: $e');
    }
  }

  // Get venue photos
  Future<List<Photo>> getVenuePhotos({
    required String venueId,
    int limit = 50,
  }) async {
    try {
      final response = await _supabase
          .from('photos')
          .select('*, owner:users!user_id(*)')
          .eq('venue_id', venueId)
          .order('created_at', ascending: false)
          .limit(limit);

      return (response as List)
          .map((item) => Photo.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get event photos
  Future<List<Photo>> getEventPhotos({
    required String eventId,
    int limit = 50,
  }) async {
    try {
      final response = await _supabase
          .from('photos')
          .select('*, owner:users!user_id(*)')
          .eq('event_id', eventId)
          .order('created_at', ascending: false)
          .limit(limit);

      return (response as List)
          .map((item) => Photo.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get tagged photos
  Future<List<Photo>> getTaggedPhotos({
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return [];

      final response = await _supabase
          .from('photos')
          .select('*, owner:users!user_id(*)')
          .contains('tagged_user_ids', [currentUser.id])
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return (response as List)
          .map((item) => Photo.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Move photo to album
  Future<Photo> movePhotoToAlbum({
    required String photoId,
    String? albumId,
  }) async {
    try {
      final response = await _supabase.from('photos').update({
        'album_id': albumId,
      }).eq('id', photoId).select('*, owner:users!user_id(*)').single();

      return Photo.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to move photo: $e');
    }
  }

  // Get recent photos from friends
  Future<List<Photo>> getFriendsPhotos({
    int limit = 50,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return [];

      final response = await _supabase.rpc('get_friends_photos', params: {
        'user_id_param': currentUser.id,
        'limit_param': limit,
      });

      return (response as List)
          .map((item) => Photo.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
