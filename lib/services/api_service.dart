import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:image_uploader/services/auth_service.dart'; // For setting content-type if necessary

class ApiService {
  // Your API key
  final String baseUri = 'https://app.sumit-never-trusts.cyou';
  final String statisticsPath = 'upload-summary';
  final String uploadImagePath = 'upload-images';
  final String getEmailPath = 'api/get-email';
  final String docIdPath = 'id';
  final String apiKey = ''; // Your API key
  final AuthService _authService = AuthService();

  Future<bool> uploadImages(List<File> images, String text) async {
    try {
      // Create a multipart request
      var uploadImagesUri = '$baseUri/$uploadImagePath';
      var uri = (text.isEmpty)
          ? Uri.parse(uploadImagesUri)
          : Uri.parse('$uploadImagesUri$docIdPath$text');
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

  Future<List<Map<String, dynamic>>?> fetchUploadStats(String start,
      String end) async {
    try {
      // Create a multipart request
      var uri = Uri.parse('$baseUri/$statisticsPath').replace(queryParameters: {
        'start': start,
        'end': end,
      });

      // Create a GET request (not multipart)
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        // Parse the JSON response
        List<dynamic> jsonResponse = json.decode(response.body);

        // Update the statistics state
        // Convert the JSON data to a List of Maps
        List<Map<String, dynamic>> statistics = jsonResponse.map((item) =>
        {
          'username': item['username'] as String,
          'total_uploads': item['total_uploads'] as int,
          'processed': item['processed'] as int,
          'failed': item['failed'] as int,
        }).toList();

        return statistics;
      } else {
        print('Failed to fetch upload stats. Status code: ${response
            .statusCode}');
        return null;
      }
    } catch (e) {
      // Handle exceptions
      print('Error fetching upload stats: $e');
      return null;
    }
  }
}
