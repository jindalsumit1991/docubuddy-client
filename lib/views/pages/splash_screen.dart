import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_uploader/views/widgets/auth_state.dart'; // Import your login or auth page

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Set a timer to navigate to AuthenticationState after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthenticationState()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background color for the splash screen
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo or branding
            Image.asset(
              'assets/logo-brain.png', // Replace with your logo path
              height: 100,
            ),
            const SizedBox(height: 30), // Space between logo and slogan

            // Slogan text with improved alignment, padding, and styling
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              // Padding around text
              child: Text(
                'Your Personal AI Assistant for Documents', // Your slogan
                textAlign: TextAlign.center, // Center align the text
                style: TextStyle(
                  fontSize: 22, // Increase font size
                  fontWeight: FontWeight.bold, // Bold for emphasis
                  color: Colors.grey, // Adjust color as needed
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Loading indicator (spinner)
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
