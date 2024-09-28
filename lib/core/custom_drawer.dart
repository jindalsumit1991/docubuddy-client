import 'package:flutter/material.dart';
import 'package:image_uploader/controller/image_controller.dart';
import 'package:image_uploader/models/image_model.dart';
import 'package:image_uploader/views/pages/home_view.dart';
import 'package:image_uploader/views/pages/image_view.dart';
import 'package:image_uploader/views/widgets/or_divder_widget.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  int _selectedIndex = -1;

  void _onItemTap(int index, Widget destinationPage) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => destinationPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageModel = ImageModel();
    final imageController = ImageController(imageModel);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Drawer(
      child: Column(
        children: [
          // Drawer Header for user information
          SizedBox(width: screenWidth * 0.2, height: screenHeight * 0.05),

          Container(
            height: 1,
            color: Colors.grey,
          ),

          // Use Expanded to make the remaining ListTiles take up the available space
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Home option
                ListTile(
                  leading: Icon(
                    Icons.home,
                    color: _selectedIndex == 0
                        ? const Color(0xFF0EA772)
                        : Colors.black54,
                  ),
                  title: const Text('Home'),
                  onTap: () {
                    _onItemTap(0, const HomeView());
                  },
                ),

                // Upload Image option
                ListTile(
                  leading: Icon(
                    Icons.upload_file,
                    color: _selectedIndex == 1
                        ? const Color(0xFF74BED7)
                        : Colors.black54,
                  ),
                  title: const Text('Upload Image'),
                  onTap: () {
                    _onItemTap(1, ImageView(imageController));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
