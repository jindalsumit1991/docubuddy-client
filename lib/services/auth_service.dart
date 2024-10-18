import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  // Sign in with email and password
  Future<void> signInUser(String email, String password) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.session == null) {
        throw Exception('Login failed: No session was created.');
      }

      print('User signed in successfully: ${response.session!.user}');
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  // Sign out the user
  Future<void> signOut() async {
    try {
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
}
