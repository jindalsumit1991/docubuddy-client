// ignore_for_file: avoid_print

import 'dart:io';
import 'package:image_uploader/utils/api_service.dart';

import '../models/image_model.dart';
import '../utils/image_picker_service.dart';

class ImageController {
  final ImageModel _imageModel;
  final ImagePickerService _imagePickerService = ImagePickerService();
  final ApiService _apiService = ApiService();

  ImageController(this._imageModel);

  Future<void> pickImageFromGallery() async {
    final File? selectedImage =
        await _imagePickerService.pickImageFromGallery();
    if (selectedImage != null) {
      _imageModel.setImage(selectedImage);
    }
  }

  Future<void> pickImageFromCamera() async {
    final File? selectedImage = await _imagePickerService.pickImageFromCamera();
    if (selectedImage != null) {
      _imageModel.setImage(selectedImage);
    }
  }

  File? get image => _imageModel.imageFile;

  void clearImage() {
    _imageModel.clearImage();
  }

  Future<int> uploadImage(File? image) async {
    if (image == null) {
      print("No image selected for upload.");
      return 2;
    }

    try {
      final response = await _apiService.uploadImage(image);

      if (response) {
        print("Image uploaded successfully.");
        clearImage();
        return 0;
      } else {
        print("Failed to upload the image.");
        return 1;
      }
    } catch (e) {
      print("Error uploading image: $e");
      return 1;
    }
  }
}
