// services/api_service.dart
// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:image_uploader/services/auth_service.dart'; // For setting content-type if necessary

class ApiService {
  // Your API key
  final String apiUrl = 'https://app.sumit-never-trusts.cyou/upload-images/';
  final String docIdPath = 'id/';
  final String apiKey = ''; // Your API key
  final AuthService _authService = AuthService();

  Future<bool> uploadImages(List<File> images, String text) async {
    try {
      // Create a multipart request
      var uri = (text.isEmpty)
          ? Uri.parse(apiUrl)
          : Uri.parse('$apiUrl$docIdPath$text');
      var request = http.MultipartRequest('POST', uri);

      var email = _authService.getUserEmail();
      request.headers.addAll({'username': '$email', 'hospital': '2'});

      // Attach all image files
      for (var image in images) {
        request.files
            .add(await http.MultipartFile.fromPath('files', image.path));
      }

      // Send the request
      var response = await request.send();

      if (response.statusCode == 200) {
        // Success response
        print('Upload Successful');
        return true;
      } else {
        // Error response
        print('Upload Failed: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      // Handle exceptions
      print('Error uploading images: $e');
      return false;
    }
  }
}
