import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image/image.dart' as img;

class PhotoUploadService {
  static final PhotoUploadService _instance = PhotoUploadService._internal();
  factory PhotoUploadService() => _instance;
  PhotoUploadService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;
  final ImagePicker _picker = ImagePicker();

  // Pick image from camera
  Future<XFile?> pickFromCamera() async {
    try {
      return await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
    } catch (e) {
      throw Exception('Failed to access camera: $e');
    }
  }

  // Pick image from gallery
  Future<XFile?> pickFromGallery() async {
    try {
      return await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
    } catch (e) {
      throw Exception('Failed to access gallery: $e');
    }
  }

  // Pick multiple images
  Future<List<XFile>> pickMultipleImages() async {
    try {
      return await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
    } catch (e) {
      throw Exception('Failed to pick images: $e');
    }
  }

  // Compress image
  Future<File> compressImage(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) return file;

      // Resize if too large
      final resized = img.copyResize(image, width: 1920);

      // Compress
      final compressed = img.encodeJpg(resized, quality: 85);

      // Save to temp file
      final tempDir = Directory.systemTemp;
      final tempFile = File('${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await tempFile.writeAsBytes(compressed);

      return tempFile;
    } catch (e) {
      return file;
    }
  }

  // Upload event photo
  Future<String> uploadEventPhoto({
    required String eventId,
    required File photo,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Compress photo
      final compressed = await compressImage(photo);

      // Generate filename
      final filename = 'event_${eventId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final path = 'event-photos/$eventId/$filename';

      // Upload to storage
      await _supabase.storage
          .from('media')
          .upload(path, compressed);

      // Get public URL
      final url = _supabase.storage
          .from('media')
          .getPublicUrl(path);

      // Save photo record
      await _supabase.from('event_photos').insert({
        'event_id': eventId,
        'user_id': currentUser.id,
        'photo_url': url,
        'uploaded_by_name': currentUser.userMetadata?['full_name'],
      });

      return url;
    } catch (e) {
      throw Exception('Failed to upload photo: $e');
    }
  }

  // Get event photos
  Future<List<Map<String, dynamic>>> getEventPhotos(String eventId) async {
    try {
      final response = await _supabase
          .from('event_photos')
          .select()
          .eq('event_id', eventId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      return [];
    }
  }

  // Delete photo
  Future<void> deletePhoto(String photoId, String photoUrl) async {
    try {
      // Extract path from URL
      final uri = Uri.parse(photoUrl);
      final path = uri.pathSegments.last;

      // Delete from storage
      await _supabase.storage
          .from('photos')
          .remove([path]);

      // Delete record
      await _supabase
          .from('event_photos')
          .delete()
          .eq('id', photoId);
    } catch (e) {
      throw Exception('Failed to delete photo: $e');
    }
  }

  // Report photo
  Future<void> reportPhoto({
    required String photoId,
    required String reason,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;

      await _supabase.from('photo_reports').insert({
        'photo_id': photoId,
        'reported_by': currentUser?.id,
        'reason': reason,
      });
    } catch (e) {
      throw Exception('Failed to report photo: $e');
    }
  }
}
