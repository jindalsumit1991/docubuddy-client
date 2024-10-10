import 'package:flutter/material.dart';
import 'package:image_uploader/core/custom_drawer.dart';
import 'package:image_uploader/services/auth_service.dart';
import 'package:image_uploader/views/widgets/auth_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  void _logout(BuildContext context) async {
    final AuthService _authService = AuthService();
    try {
      await _authService.signOut();

      // Clear the navigation stack and navigate to AuthState
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AuthenticationState()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      print('Logout error: $e');
      // Optionally, show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;

    if (session == null) {
      // User is not authenticated, redirect to AuthState
      Future.microtask(() {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AuthenticationState()),
          (Route<dynamic> route) => false,
        );
      });
      return const SizedBox.shrink();
    }

    return Scaffold(
      drawer: AppDrawer(
        onLogout: () => _logout(context),
      ),
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipOval(
              child: SizedBox(
                height: 30,
                width: 30,
                child: Image.asset(
                  'assets/logo.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'DocuBrain',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Text("Manage your documents here"),
      ),
    );
  }
}
