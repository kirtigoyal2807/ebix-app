import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  /// Pick image from Gallery
  Future<File?> pickFromGallery({int imageQuality = 80}) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: imageQuality,
      );

      if (image == null) return null;

      return File(image.path);
    } catch (e) {
      return null;
    }
  }

  /// Pick image from Camera
  Future<File?> pickFromCamera({int imageQuality = 80}) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: imageQuality,
      );

      if (image == null) return null;

      return File(image.path);
    } catch (e) {
      return null;
    }
  }
}
