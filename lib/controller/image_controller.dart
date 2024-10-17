// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_uploader/models/image_model.dart';
import 'package:image_uploader/services/api_service.dart';
import 'package:image_uploader/services/image_picker_service.dart';

class ImageController extends ChangeNotifier {
  final ImageModel _imageModel;
  final ImagePickerService _imagePickerService = ImagePickerService();
  final ApiService _apiService = ApiService();
  List<File> _images = [];
  static const String emptyString = "";

  ImageController(this._imageModel);

  void addImage(File image) {
    _images.add(image);
    notifyListeners();
  }

  void removeImage(int index) {
    if (index >= 0 && index < _images.length) {
      _images.removeAt(index);
      notifyListeners();
    }
  }

  void clearImages() {
    _images.clear();
    notifyListeners();
  }

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

  Future<int> uploadImages([String text = '']) async {
    if (_images.isEmpty) {
      print("No images selected for upload.");
      return 2;
    }

    try {
      final response = await _apiService.uploadImages(_images, text);

      if (response) {
        print("Images uploaded successfully.");
        clearImages();
        return 0;
      } else {
        print("Failed to upload the images.");
        return 1;
      }
    } catch (e) {
      print("Error uploading images: $e");
      return 1;
    }
  }
}
