import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ImageService {
  static final supabase = Supabase.instance.client;
  
  /// Picks multiple images from gallery
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

  /// Upload image to Supabase storage
  static Future<String?> uploadImage(Uint8List imageBytes, String fileName) async {
    try {
      final path = 'guesthouse_images/$fileName';
      
      // Upload the binary file to storage
      await supabase.storage
          .from('guesthouse-images')
          .uploadBinary(
            path,
            imageBytes,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: false,
            ),
          );

      // Get public URL for the uploaded image
      final publicUrl = supabase.storage
          .from('guesthouse-images')
          .getPublicUrl(path);

      print('✅ Image uploaded successfully: $publicUrl');
      return publicUrl;
    } catch (e) {
      print('❌ Error uploading image: $e');
      return null;
    }
  }

  /// Delete image from Supabase storage
  static Future<bool> deleteImage(String imageUrl) async {
    try {
      // Extract the file path from the public URL
      // Example: https://project.supabase.co/storage/v1/object/public/guesthouse-images/guesthouse_images/file.jpg
      final Uri uri = Uri.parse(imageUrl);
      
      // Get the path after 'public/'
      final pathIndex = uri.pathSegments.indexOf('public');
      if (pathIndex == -1) {
        print('❌ Invalid image URL format');
        return false;
      }
      
      final filePath = uri.pathSegments.sublist(pathIndex + 1).join('/');

      // Delete the file from storage
      await supabase.storage
          .from('guesthouse-images')
          .remove([filePath]);

      print('✅ Image deleted successfully: $filePath');
      return true;
    } catch (e) {
      print('❌ Error deleting image: $e');
      return false;
    }
  }

  /// Delete multiple images
  static Future<bool> deleteMultipleImages(List<String> imageUrls) async {
    try {
      for (String url in imageUrls) {
        await deleteImage(url);
      }
      return true;
    } catch (e) {
      print('❌ Error deleting multiple images: $e');
      return false;
    }
  }
}
