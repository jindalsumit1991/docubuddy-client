// views/image_view.dart

import 'package:flutter/material.dart';
import 'package:image_uploader/controller/image_controller.dart';
import 'package:image_uploader/core/custom_drawer.dart';
import 'package:image_uploader/services/auth_service.dart';
import 'package:image_uploader/utils/snack_bar_helpers.dart';
import 'package:image_uploader/views/pages/image_upload_body.dart';
import 'package:image_uploader/views/widgets/auth_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ImageView extends StatefulWidget {
  final ImageController _controller;

  const ImageView(this._controller, {super.key});

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
  ImageViewState createState() => ImageViewState();
}

class ImageViewState extends State<ImageView> {
  bool isUploading = false;

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
      drawer: AppDrawer(onLogout: () => widget._logout(context)),
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
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: ImageUploadBody(
                  controller: widget._controller,
                  isUploading: isUploading,
                  onUpload: () async {
                    setState(() {
                      isUploading = true;
                    });

                    int result = await widget._controller
                        .uploadImage(widget._controller.image);

                    setState(() {
                      isUploading = false;
                    });

                    if (result == 0) {
                      showSuccessSnackBar(
                          context, "Image uploaded successfully!");
                    } else if (result == 2) {
                      showNoImageErrorSnackBar(
                          context, "Select an image to upload.");
                    } else {
                      showErrorSnackBar(context, "Failed to upload the image.");
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
