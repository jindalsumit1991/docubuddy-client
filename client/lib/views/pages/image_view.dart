// views/image_view.dart
// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_uploader/controller/image_controller.dart';
import 'package:image_uploader/core/custom_drawer.dart';
import 'package:image_uploader/utils/snack_bar_helpers.dart';
import 'package:image_uploader/views/widgets/camera_button_widget.dart';
import 'package:image_uploader/views/widgets/choose_from_gallery_container.dart';
import 'package:image_uploader/views/widgets/or_divder_widget.dart';
import 'package:image_uploader/views/widgets/upload_button.dart';

import '../widgets/header_widget.dart';

class ImageView extends StatefulWidget {
  final ImageController _controller;

  const ImageView(this._controller, {super.key});

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
        title: SvgPicture.asset(
          'assets/spotify.svg',
          height: 70,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.03,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HeaderWidget(),
                    SizedBox(height: screenHeight * 0.05),
                    SelectFileContainer(
                      onTap: () async {
                        await widget._controller.pickImageFromGallery();
                        setState(() {});
                      },
                      image: widget._controller.image,
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    const OrDivderWidget(),
                    SizedBox(height: screenHeight * 0.05),
                    Center(
                      child: CameraButton(
                        onTap: () async {
                          await widget._controller.pickImageFromCamera();
                          setState(() {});
                        },
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: RoundedButton(
                text: "Upload Image",
                loading: isUploading,
                onPressed: () async {
                  setState(() {
                    isUploading = true;
                  });

                  bool success = await widget._controller
                      .uploadImage(widget._controller.image);

                  setState(() {
                    isUploading = false;
                  });

                  if (success) {
                    showSuccessSnackBar(
                        context, "Image uploaded successfully!");
                  } else {
                    showErrorSnackBar(context, "Failed to upload the image.");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
