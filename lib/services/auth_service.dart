import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  // Sign in with email and password
  Future<void> signInUser(String email, String password) async {
    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
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
      await Supabase.instance.client.auth.signOut();
    } catch (e) {
      throw Exception('Logout error: ${e.toString()}');
    }
  }

// Check if user is authenticated
  bool isAuthenticated() {
    return Supabase.instance.client.auth.currentSession != null;
  }
}
