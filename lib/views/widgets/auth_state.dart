import 'package:flutter/material.dart';
import 'package:image_uploader/views/pages/home_view.dart';
import 'package:image_uploader/views/pages/login_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthenticationState extends StatefulWidget {
  const AuthenticationState({super.key});

  @override
  AuthenticationStateState createState() => AuthenticationStateState();
}

class AuthenticationStateState extends State<AuthenticationState> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = Supabase.instance.client.auth.currentSession;

        if (session != null) {
          // User is authenticated
          return const HomeView();
        } else {
          // User is not authenticated
          return const LoginPage();
        }
      },
    );
  }
}
