// camera_button.dart
import 'package:flutter/material.dart';

class CameraButton extends StatelessWidget {
  final VoidCallback onTap;

  const CameraButton({required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.02,
          horizontal: screenWidth * 0.05,
        ),
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(screenWidth * 0.08),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt,
              color: Colors.white,
              size: screenWidth * 0.07,
            ),
            SizedBox(width: screenWidth * 0.02),
            Text(
              'Click New Photo',
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.045,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
