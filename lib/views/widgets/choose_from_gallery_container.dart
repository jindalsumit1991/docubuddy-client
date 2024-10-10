import 'package:flutter/material.dart';

class SelectFileContainer extends StatelessWidget {
  final Function()? onTap;
  final dynamic image; // Adjust this type based on your actual image type (File or something else)

  const SelectFileContainer({this.onTap, this.image, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[400]!),
        ),
        child: image != null
            ? ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(
            image,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        )
            : Center(
          child: Text(
            'No image selected',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
