import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_uploader/controller/image_controller.dart';
import 'package:image_uploader/core/custom_drawer.dart';
import 'package:image_uploader/services/auth_service.dart';
import 'package:image_uploader/utils/snack_bar_helpers.dart';
import 'package:image_uploader/views/pages/image_upload_body.dart';
import 'package:image_uploader/views/widgets/app_bar.dart';
import 'package:image_uploader/views/widgets/auth_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ImageView extends StatefulWidget {
  final ImageController _controller;

  const ImageView(this._controller, {super.key});

  @override
  ImageViewState createState() => ImageViewState();
}

class ImageViewState extends State<ImageView> {
  bool isUploading = false;
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

    return Scaffold(
      drawer: AppDrawer(
        onLogout: () async {
          final AuthService authService = AuthService();
          try {
            await authService.signOut();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => const AuthenticationState()),
              (Route<dynamic> route) => false,
            );
          } catch (e) {
            print('Logout error: $e');
          }
        },
        userRole: userRole ?? 'staff',
      ),
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ImageUploadBody(
          controller: widget._controller,
          isUploading: isUploading,
          onUpload: (List<File> files) async {
            if (files.isEmpty) {
              showNoImageErrorSnackBar(
                  context, "Select at least one image to upload.");
              return false;
            }

            setState(() {
              isUploading = true;
            });

            // Clear previous images and add newly selected files
            widget._controller.clearImages();
            for (var file in files) {
              widget._controller.addImage(file);
            }

            int result = await widget._controller.uploadImages();

            setState(() {
              isUploading = false;
            });

            if (result == 0) {
              showSuccessSnackBar(context, "All images uploaded successfully!");
              return true;
            } else if (result == 2) {
              showNoImageErrorSnackBar(
                  context, "No images were selected for upload.");
              return false;
            } else {
              showErrorSnackBar(
                  context, "Failed to upload one or more images.");
              return false;
            }
          },
        ),
      ),
    );
  }
}
