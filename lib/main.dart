import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_uploader/views/widgets/auth_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://hezgmrrpneheliezeind.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhlemdtcnJwbmVoZWxpZXplaW5kIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjc3MzMyNDMsImV4cCI6MjA0MzMwOTI0M30.mJcb3DNgGk5dalOKRwg5_HkWhOO2qinKfdRzujvkFUk',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple Image Uploader',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
        primarySwatch: Colors.blue,
      ),
      home: const AuthenticationState(),
    );
  }
}
