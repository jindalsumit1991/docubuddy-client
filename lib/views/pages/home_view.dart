import 'package:flutter/material.dart';
import 'package:image_uploader/controller/image_controller.dart';
import 'package:image_uploader/core/custom_drawer.dart'; // Import the drawer
import 'package:image_uploader/models/image_model.dart';
import 'package:image_uploader/services/auth_service.dart';
import 'package:image_uploader/utils/docu_colors.dart';
import 'package:image_uploader/views/pages/custom_upload_view.dart'; // Manual Upload page
import 'package:image_uploader/views/pages/image_view.dart'; // AI Upload page
import 'package:image_uploader/views/widgets/auth_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Define custom pastel colors
const Color pastelBlue = Color(0xFF83cce0);
const Color pastelGreen = Color(0xFFd8ddde);

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  String? userRole;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final AuthService authService = AuthService();
    final role = await authService.fetchUserRole();
    setState(() {
      userRole = role ?? 'staff';
    });
  }

  void _logout(BuildContext context) async {
    final AuthService authService = AuthService();
    try {
      await authService.signOut();

      // Clear the navigation stack and navigate to AuthState
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AuthenticationState()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      print('Logout error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;

    if (session == null) {
      Future.microtask(() {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AuthenticationState()),
          (Route<dynamic> route) => false,
        );
      });
      return const SizedBox.shrink();
    }

    final imageModel = ImageModel();
    final imageController = ImageController(imageModel);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
            color: Colors.black), // Set the hamburger icon color to black
      ),
      drawer: AppDrawer(
          onLogout: () => _logout(context), userRole: userRole ?? 'staff'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),

            // Branding Section
            Expanded(
              flex: 3,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logo-brain.png',
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'DocuBrain',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Text(
                      'AI-powered document management',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 50),

            // Grid layout for options
            Expanded(
              flex: 2,
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                // Create a grid with 2 columns
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  // AI Upload Option
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ImageView(imageController)),
                      );
                    },
                    child: Card(
                      color: DocuColors.aquamarine_blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      child: AspectRatio(
                        aspectRatio: 2 / 1,
                        // Setting a 2:1 width to height ratio for the rectangle shape
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 30, // Adjusted size
                                child: Image.asset(
                                  'assets/ai-upload.png',
                                  color: DocuColors.blue_dianne,
                                  height: 40,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'AI Upload',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: DocuColors.blue_dianne,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Manual Upload Option
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ImageUploadWithTextView(imageController)),
                      );
                    },
                    child: Card(
                      color: DocuColors.pale_slate,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      child: AspectRatio(
                        aspectRatio: 2 / 1,
                        // Setting a 2:1 width to height ratio for the rectangle shape
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 30, // Adjusted size
                                child: Image.asset(
                                  'assets/write.png',
                                  color: DocuColors.blue_dianne,
                                  height: 40,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Manual Upload',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: DocuColors.blue_dianne,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
