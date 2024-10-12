// models/image_model.dart
import 'dart:io';

class ImageModel {
  File? _imageFile;

  File? get imageFile => _imageFile;

  void setImage(File? image) {
    _imageFile = image;
  }

  String? getImage(File? image) {
    return _imageFile?.path;
  }

  void clearImage() {
    _imageFile = null;
  }
}
