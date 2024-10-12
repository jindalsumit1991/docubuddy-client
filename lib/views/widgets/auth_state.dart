// auth_state.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_uploader/services/auth_service.dart';
import 'package:image_uploader/services/user_role_provider.dart';
import 'package:image_uploader/views/pages/home_view.dart';
import 'package:image_uploader/views/pages/login_view.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthenticationState extends StatefulWidget {
  const AuthenticationState({super.key});

  @override
  AuthenticationStateState createState() => AuthenticationStateState();
}

class AuthenticationStateState extends State<AuthenticationState> {
  bool _loading = true;
  final supabaseClient = Supabase.instance.client;
  StreamSubscription<AuthState>? _authSubscription;

  @override
  void initState() {
    super.initState();

    // Schedule _initialize() to run after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialize();
    });

    // Listen to auth state changes
    _authSubscription = supabaseClient.auth.onAuthStateChange.listen((event) {
      setState(() {
        _loading = true;
      });

      // Schedule _initialize() to run after the current frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initialize();
      });
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initialize() async {
    final session = supabaseClient.auth.currentSession;
    final userRoleProvider =
        Provider.of<UserRoleProvider>(context, listen: false);

    if (session != null) {
      // User is authenticated
      final AuthService authService = AuthService();
      final role = authService.getUserRole();

      // Schedule setUserRole to avoid calling notifyListeners during build
      Future.microtask(() {
        userRoleProvider.setUserRole(role ?? '');
      });

      setState(() {
        _loading = false;
      });
    } else {
      // User is not authenticated

      // Schedule setUserRole to avoid calling notifyListeners during build
      Future.microtask(() {
        userRoleProvider.setUserRole('');
      });

      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      // Show a loading indicator while fetching the user role
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final session = supabaseClient.auth.currentSession;

    if (session != null) {
      // User is authenticated
      return const HomeView();
    } else {
      // User is not authenticated
      return const LoginPage();
    }
  }
}
