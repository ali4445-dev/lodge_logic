import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class ImageService {
  static final ImagePicker _picker = ImagePicker();

  /// Picks an image from gallery or camera
  /// source = ImageSource.gallery or ImageSource.camera
 static Future<List<Uint8List>> pickMultipleImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? picked = await picker.pickMultiImage();

    if (picked == null) return [];

    List<Uint8List> images = [];

    for (var img in picked) {
      Uint8List bytes = await img.readAsBytes();
      images.add(bytes);
    }

    return images;
  }
}
