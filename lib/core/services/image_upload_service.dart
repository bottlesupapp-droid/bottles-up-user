import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ImageUploadService {
  static final ImageUploadService _instance = ImageUploadService._internal();
  factory ImageUploadService() => _instance;
  ImageUploadService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;
  final ImagePicker _picker = ImagePicker();

  /// Pick image from gallery
  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to pick image: $e');
    }
  }

  /// Pick image from camera
  Future<File?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to take photo: $e');
    }
  }

  /// Pick multiple images from gallery
  Future<List<File>> pickMultipleImages({int maxImages = 5}) async {
    try {
      // Pick images one by one until maxImages or user cancels
      final images = <File>[];

      for (int i = 0; i < maxImages; i++) {
        final image = await pickImageFromGallery();
        if (image == null) break;
        images.add(image);
      }

      return images;
    } catch (e) {
      throw Exception('Failed to pick images: $e');
    }
  }

  /// Upload image to Supabase Storage
  /// Returns the public URL of the uploaded image
  Future<String> uploadImage(File imageFile, String bucket, {String? folder}) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      // Generate unique filename
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final pathParts = imageFile.path.split('.');
      final extension = pathParts.isNotEmpty ? '.${pathParts.last}' : '.jpg';
      final filename = '${timestamp}_$userId$extension';

      // Build path
      final filePath = folder != null ? '$folder/$filename' : filename;

      // Upload to Supabase Storage
      await _supabase.storage.from(bucket).upload(
            filePath,
            imageFile,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: false,
            ),
          );

      // Get public URL
      final publicUrl = _supabase.storage.from(bucket).getPublicUrl(filePath);

      return publicUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  /// Upload multiple images
  /// Returns list of public URLs
  Future<List<String>> uploadMultipleImages(
    List<File> imageFiles,
    String bucket, {
    String? folder,
    Function(int current, int total)? onProgress,
  }) async {
    final urls = <String>[];

    for (int i = 0; i < imageFiles.length; i++) {
      final url = await uploadImage(imageFiles[i], bucket, folder: folder);
      urls.add(url);
      onProgress?.call(i + 1, imageFiles.length);
    }

    return urls;
  }

  /// Delete image from Supabase Storage
  Future<void> deleteImage(String imageUrl, String bucket) async {
    try {
      // Extract file path from URL
      final uri = Uri.parse(imageUrl);
      final pathSegments = uri.pathSegments;

      // Find the bucket name in the path and get everything after it
      final bucketIndex = pathSegments.indexOf(bucket);
      if (bucketIndex == -1) {
        throw Exception('Invalid image URL');
      }

      final filePath = pathSegments.sublist(bucketIndex + 1).join('/');

      // Delete from storage
      await _supabase.storage.from(bucket).remove([filePath]);
    } catch (e) {
      throw Exception('Failed to delete image: $e');
    }
  }

  /// Get storage bucket URLs
  String getPublicUrl(String bucket, String filePath) {
    return _supabase.storage.from(bucket).getPublicUrl(filePath);
  }

  /// Create storage buckets if they don't exist (admin only)
  /// Typical buckets: 'venue-images', 'rating-images', 'announcement-images', 'chat-images'
  Future<void> createBucket(String bucketName, {bool isPublic = true}) async {
    try {
      await _supabase.storage.createBucket(
        bucketName,
        BucketOptions(public: isPublic),
      );
    } catch (e) {
      // Bucket might already exist
      if (!e.toString().contains('already exists')) {
        throw Exception('Failed to create bucket: $e');
      }
    }
  }
}
