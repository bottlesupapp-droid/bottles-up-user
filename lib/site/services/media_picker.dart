import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../rules/post_rules.dart';
import '../site_error.dart';

/// Chooses photos and videos from the phone's library. Replaced in tests.
abstract class MediaPicker {
  /// Up to [max] photos; an empty list when the person chose none.
  Future<List<PickedMedia>> photos({required int max});

  /// One video, or null when none was chosen.
  Future<PickedMedia?> video();
}

class DeviceMediaPicker implements MediaPicker {
  const DeviceMediaPicker();

  @override
  Future<List<PickedMedia>> photos({required int max}) async {
    try {
      // Scaled down and re-encoded on the phone: a photo from a modern camera is far above the 10 MB the website takes.
      final files = await ImagePicker().pickMultiImage(maxWidth: 1600, maxHeight: 2000, imageQuality: 88, limit: max);
      return [
        for (final f in files.take(max))
          PickedMedia(path: f.path, type: f.mimeType ?? typeForName(f.name) ?? typeForName(f.path) ?? 'image/jpeg', bytes: await f.length()),
      ];
    } catch (error) {
      logProblem('choose photos', error);
      throw const SiteException('We could not open your photos. Check that BottlesUp may use them in Settings.');
    }
  }

  @override
  Future<PickedMedia?> video() async {
    try {
      final f = await ImagePicker().pickVideo(source: ImageSource.gallery, maxDuration: const Duration(seconds: 60));
      if (f == null) return null;
      final controller = VideoPlayerController.file(File(f.path));
      try {
        await controller.initialize();
        return PickedMedia(
          path: f.path,
          type: f.mimeType ?? typeForName(f.name) ?? typeForName(f.path) ?? 'video/mp4',
          bytes: await f.length(),
          durationMs: controller.value.duration.inMilliseconds,
          width: controller.value.size.width.round(),
          height: controller.value.size.height.round(),
        );
      } finally {
        await controller.dispose();
      }
    } catch (error) {
      logProblem('choose a video', error);
      throw const SiteException('We could not open that video. Try another one.');
    }
  }
}

final mediaPickerProvider = Provider<MediaPicker>((ref) => const DeviceMediaPicker());
