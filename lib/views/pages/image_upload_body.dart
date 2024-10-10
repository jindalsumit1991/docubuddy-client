import 'package:flutter/widgets.dart';
import 'package:image_uploader/controller/image_controller.dart';
import 'package:image_uploader/views/widgets/camera_button_widget.dart';
import 'package:image_uploader/views/widgets/choose_from_gallery_container.dart';
import 'package:image_uploader/views/widgets/header_widget.dart';
import 'package:image_uploader/views/widgets/or_divder_widget.dart';
import 'package:image_uploader/views/widgets/upload_button.dart';

class ImageUploadBody extends StatelessWidget {
  final ImageController _controller;
  final bool isUploading;
  final Function() onUpload;

  const ImageUploadBody({
    Key? key,
    required ImageController controller,
    required this.isUploading,
    required this.onUpload,
  })  : _controller = controller,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HeaderWidget(),
        SizedBox(height: screenHeight * 0.05),
        SelectFileContainer(
          onTap: () async {
            await _controller.pickImageFromGallery();
          },
          image: _controller.image,
        ),
        SizedBox(height: screenHeight * 0.05),
        const OrDivderWidget(),
        SizedBox(height: screenHeight * 0.05),
        Center(
          child: CameraButton(
            onTap: () async {
              await _controller.pickImageFromCamera();
            },
          ),
        ),
        SizedBox(height: screenHeight * 0.05),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: RoundedButton(
            text: "Upload Image",
            loading: isUploading,
            onPressed: onUpload,
          ),
        ),
      ],
    );
  }
}
