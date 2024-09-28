// services/api_service.dart
// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // For setting content-type if necessary

class ApiService {
  // Your API key
  final String apiUrl = 'https://app.sumit-never-trusts.cyou/upload-images/';
  final String apiKey = ''; // Your API key

  Future<bool> uploadImage(File image) async {
    try {
      // Create a multipart request
      //var uri = Uri.parse('$apiUrl?key=$apiKey');
      var uri = Uri.parse('$apiUrl');
      var request = http.MultipartRequest('POST', uri);

      request.headers.addAll({'username': 'rashi', 'hospital': '2'});
      // Attach the image file
      request.files.add(await http.MultipartFile.fromPath(
        'files',
        image.path
      ));

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
      print('Error uploading image: $e');
      return false;
    }
  }
}
