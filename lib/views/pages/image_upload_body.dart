import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_uploader/controller/image_controller.dart';
import 'package:image_uploader/utils/docu_colors.dart';
import 'package:image_uploader/views/widgets/custom_button.dart';

class ImageUploadBody extends StatefulWidget {
  final ImageController controller;
  final bool isUploading;
  final Future<bool> Function(List<File>) onUpload;
  final String? inputText;
  final Function(String)? onTextChanged;

  const ImageUploadBody({
    Key? key,
    required this.controller,
    required this.isUploading,
    required this.onUpload,
    this.inputText,
    this.onTextChanged,
  }) : super(key: key);

  @override
  _ImageUploadBodyState createState() => _ImageUploadBodyState();
}

class _ImageUploadBodyState extends State<ImageUploadBody> {
  final List<File> _selectedFiles = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null) {
      setState(() {
        _selectedFiles.addAll(images.map((xFile) => File(xFile.path)));
      });
    }
  }

  Future<void> _captureImage() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _selectedFiles.add(File(photo.path));
      });
    }
  }

  void _removeFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
  }

  Future<void> _handleUpload() async {
    if (_selectedFiles.isNotEmpty) {
      bool success = await widget.onUpload(_selectedFiles);
      if (success) {
        setState(() {
          _selectedFiles.clear();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildPreviewBox(),
                  const SizedBox(height: 24),
                  _buildDivider(),
                  const SizedBox(height: 24),
                  _buildCameraButton(),
                  const SizedBox(height: 24),
                  ..._buildSelectedFiles(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
        if (widget.onTextChanged != null) ...[
          _buildTextField(),
          const SizedBox(height: 24),
        ],
        _buildUploadButton(),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildPreviewBox() {
    return GestureDetector(
      onTap: _pickImages,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: DocuColors.geyser,
          borderRadius: BorderRadius.circular(16),
        ),
        child: _selectedFiles.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  _selectedFiles.first,
                  fit: BoxFit.cover,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_a_photo,
                    size: 64,
                    color: DocuColors.bismark,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Upload images from gallery',
                    style: TextStyle(color: DocuColors.bismark),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('OR', style: TextStyle(color: Colors.grey[600])),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }

  Widget _buildCameraButton() {
    return CustomButton(
      onPressed: _captureImage,
      icon: Icons.camera_alt,
      label: 'Take Photo with Camera',
      backgroundColor: const Color(0xff4e8cac),
    );
  }

  List<Widget> _buildSelectedFiles() {
    return _selectedFiles.asMap().entries.map((entry) {
      int idx = entry.key;
      File file = entry.value;
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                file.path.split('/').last,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: Icon(Icons.close, color: DocuColors.blue_dianne),
              onPressed: () => _removeFile(idx),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildTextField() {
    return TextField(
      onChanged: widget.onTextChanged,
      decoration: InputDecoration(
        hintText: 'Enter Document ID',
        filled: true,
        fillColor: DocuColors.geyser,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        prefixIcon: const Icon(Icons.description),
      ),
    );
  }

  Widget _buildUploadButton() {
    return CustomButton(
      onPressed: _handleUpload,
      label: 'Upload Images',
      isLoading: widget.isUploading,
      backgroundColor: DocuColors.blue_dianne,
    );
  }
}
