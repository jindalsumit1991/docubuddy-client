import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the width and height of the screen
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Responsive Font Size for Title
        Text(
          "Upload a Photo",
          style: TextStyle(
            color: const Color(0xFF212121),
            fontSize: screenWidth * 0.08,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: screenHeight * 0.03),

        // Responsive Font Size for Subtitle
        Text(
          "A simple application to upload an image from gallery or camera.",
          style: TextStyle(
            color: const Color(0xFF212121),
            fontSize: screenWidth * 0.045, // 4.5% of screen width
            fontWeight: FontWeight.w400,
            letterSpacing: 0.20,
          ),
        ),
      ],
    );
  }
}
