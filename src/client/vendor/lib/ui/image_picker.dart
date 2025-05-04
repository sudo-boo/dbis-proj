// lib/utils/image_picker.dart
import 'package:image_picker/image_picker.dart';

/// A simple utility wrapper around the image_picker plugin
/// Provides methods for picking single or multiple images
class AppImagePicker {
  AppImagePicker._(); // private constructor

  static final ImagePicker _picker = ImagePicker();

  /// Pick a single image from gallery or camera
  /// [maxWidth] and [maxHeight] are in pixels
  /// [imageQuality] is 0-100 (null to disable compression)
  static Future<XFile?> pickImage({
    ImageSource source = ImageSource.gallery,
    double? maxWidth = 1800.0,
    double? maxHeight = 1800.0,
    int? imageQuality = 80,
  }) async {
    try {
      return await _picker.pickImage(
        source: source,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
      );
    } catch (e) {
      // Handle or log error
      return null;
    }
  }

  /// Pick multiple images from gallery
  /// [maxWidth] and [maxHeight] are in pixels
  /// [imageQuality] is 0-100 (null to disable compression)
  static Future<List<XFile>> pickMultiImage({
    double? maxWidth = 1800.0,
    double? maxHeight = 1800.0,
    int? imageQuality = 80,
  }) async {
    try {
      final List<XFile> files = await _picker.pickMultiImage(
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
      );
      return files ?? <XFile>[];
    } catch (e) {
      // Handle or log error
      return <XFile>[];
    }
  }
}
