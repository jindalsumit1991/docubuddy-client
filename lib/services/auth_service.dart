import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_uploader/models/user_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;
  final String baseUri = 'https://app.sumit-never-trusts.cyou';
  final String getEmailPath = 'api/get-email';

  static const String KEY_USERNAME = 'cached_username';
  static const String KEY_INST_ID = 'cached_inst_id';
  static const String KEY_ROLE = 'cached_role';

  Future<void> signInUser(String emailOrUsername, String password) async {
    try {
      String? email = emailOrUsername;

      if (!emailOrUsername.contains('@')) {
        // Find the specific username
        final response = await _client
            .from('usernames')
            .select('username, role, institution_id')
            .eq('username', emailOrUsername)
            .single();
        print('Username query result: $response'); // Debug print

        if (response.isEmpty) {
          throw Exception('Username not found');
        }

        UserInfo userInfo = UserInfo(response['username'] as String,
            response['role'] as String, response['institution_id'] as int);

        email = await getEmailFromUsername(emailOrUsername);

        final authResponse = await _client.auth.signInWithPassword(
          email: email.toString(),
          password: password,
        );

        if (authResponse.session == null) {
          throw Exception('Login failed: No session was created.');
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(KEY_USERNAME, emailOrUsername);
        await prefs.setInt(KEY_INST_ID, userInfo.institutionId);
        await prefs.setString(KEY_ROLE, userInfo.role);
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

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(KEY_USERNAME);
      await prefs.remove(KEY_ROLE);
      await prefs.remove(KEY_INST_ID);
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
    String? role = await getCachedUserRole();
    if (role == null) {
      final userId = _client.auth.currentUser?.id;
      final response = await Supabase.instance.client
          .from('user_roles')
          .select('role')
          .eq('id', userId.toString())
          .single();
      role = response['role'] as String?;
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(KEY_ROLE, role.toString());
    }
    return role;
  }

  Future<String?> getCachedUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(KEY_ROLE);
  }

  Future<int?> getInstitutionId() async {
    int? instId = await getCachedInstitutionId();

    if (instId == null) {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return null;

      final response = await Supabase.instance.client
          .from('usernames')
          .select('institution_id')
          .eq('user_id', user.id)
          .single();
      instId = response['institution_id'] as int?;
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt(KEY_INST_ID, instId!);
    }
    return instId;
  }

  Future<int?> getCachedInstitutionId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(KEY_INST_ID);
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

  Future<String?> getCachedUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(KEY_USERNAME);
  }

  Future<String?> getUsername() async {
    String? username = await getCachedUsername();
    if (username == null) {
      final userId = _client.auth.currentUser?.id;
      final response = await Supabase.instance.client
          .from('usernames')
          .select('username')
          .eq('user_id', userId.toString())
          .single();
      username = response['username'] as String?;
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(KEY_USERNAME, username.toString());
      return username;
    }
    return username;
  }

  Future<String?> getEmailFromUsername(String username) async {
    try {
      print('Fetching email for username: $username');
      print('URL: $baseUri/$getEmailPath/$username');

      final response =
          await http.get(Uri.parse('$baseUri/$getEmailPath/$username'));
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
