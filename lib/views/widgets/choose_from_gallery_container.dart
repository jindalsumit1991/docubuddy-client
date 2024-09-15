// widgets/select_file_container.dart
import 'package:flutter/material.dart';
import 'dart:io'; // For File handling

class SelectFileContainer extends StatelessWidget {
  final VoidCallback? onTap;
  final File? image;

  const SelectFileContainer({this.onTap, this.image, super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: screenHeight * 0.25, // 25% of screen height
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(screenWidth * 0.05),
          border: Border.all(
            color: Colors.greenAccent,
            width: 2,
          ),
        ),
        child: image == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image,
                    size: screenWidth * 0.1,
                    color: Colors.grey,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    'Choose from Gallery',
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      color: Colors.grey,
                    ),
                  ),
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(screenWidth * 0.05),
                child: Image.file(
                  image!,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return Center(
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.grey,
                        size: screenWidth * 0.1,
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
