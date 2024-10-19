import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;
  final String baseUri = 'https://app.sumit-never-trusts.cyou';
  final String getEmailPath = 'api/get-email';

  Future<void> signInUser(String emailOrUsername, String password) async {
    try {
      String? email = emailOrUsername;

      if (!emailOrUsername.contains('@')) {
        // First check if we can query the table
        final usersQuery = await _client.from('usernames').select().limit(1);
        print('Test query result: $usersQuery'); // Debug print

        // Then try to find specific username
        final response = await _client
            .from('usernames')
            .select('user_id')
            .eq('username', emailOrUsername);
        print('Username query result: $response'); // Debug print

        if (response.isEmpty) {
          throw Exception('Username not found');
        }

        email = await getEmailFromUsername(emailOrUsername);

        final authResponse = await _client.auth.signInWithPassword(
          email: email.toString(),
          password: password,
        );

        if (authResponse.session == null) {
          throw Exception('Login failed: No session was created.');
        }
      }

      // Rest of your code for authentication
    } catch (e) {
      print('Error in signInUser: $e'); // Debug print
      throw Exception('Login error: $e');
    }
  }

  // Sign out the user
  Future<void> signOut() async {
    try {
      if (_client.auth.currentSession == null) {
        // Already signed out, just navigate to login
        return;
      }
      await _client.auth.signOut();
    } catch (e) {
      throw Exception('Logout error: ${e.toString()}');
    }
  }

// Check if user is authenticated
  bool isAuthenticated() {
    return _client.auth.currentSession != null;
  }

  // Get user role from JWT
  Future<String?> fetchUserRole() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return null;

    final response = await Supabase.instance.client
        .from('user_roles')
        .select('role')
        .eq('id', user.id)
        .single();

    return response['role'] as String?;
  }

  // Helper method to parse JWT
  Map<String, dynamic> _parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    return json.decode(payload);
  }

  String _decodeBase64(String str) {
    var output = str.replaceAll('-', '+').replaceAll('_', '/');
    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Invalid base64 string');
    }
    return utf8.decode(base64Url.decode(output));
  }

  Future<Map<String, dynamic>?> fetchUserProfile() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return null;

    try {
      final response =
          await _client.from('profiles').select('*').eq('id', userId).single();

      return response;
    } catch (e) {
      throw Exception('Error fetching profile: $e');
    }
  }

  String? getUserEmail() {
    final user = _client.auth.currentUser;
    return user?.email;
  }

  Future<String?> getEmailFromUsername(String username) async {
    try {
      print('Fetching email for username: $username');
      print('URL: $baseUri/$getEmailPath/$username');

      final response = await http.get(Uri.parse('$baseUri/$getEmailPath/$username'));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final email = jsonDecode(response.body)['email'];
        print('Decoded email: $email');
        return email;
      }
      return null;
    } catch (e) {
      print('Error getting email: $e');
      return null;
    }
  }
}
