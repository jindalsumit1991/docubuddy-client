import 'package:flutter/material.dart';
import 'package:image_uploader/controller/image_controller.dart';
import 'package:image_uploader/models/image_model.dart';
import 'package:image_uploader/views/pages/custom_upload_view.dart';
import 'package:image_uploader/views/pages/home_view.dart';
import 'package:image_uploader/views/pages/image_view.dart';
import 'package:image_uploader/views/pages/manage_users_view.dart';

class AppDrawer extends StatefulWidget {
  final VoidCallback onLogout;

  //final String userRole;

  //const AppDrawer({super.key, required this.onLogout, required this
  // .userRole});
  const AppDrawer({super.key, required this.onLogout});

  @override
  AppDrawerState createState() => AppDrawerState();
}

class AppDrawerState extends State<AppDrawer> {
  static int _selectedIndex = -1;

  void _onItemTap(int index, Widget destinationPage) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      Navigator.pop(context);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => destinationPage),
      );
    } else {
      Navigator.pop(context); // Just close the drawer if it's the same page
    }
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
                    Icons.home_outlined,
                    color: _selectedIndex == 0
                        ? const Color(0xFF74BED7)
                        : Colors.black54,
                  ),
                  title: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Home ',
                          style: DefaultTextStyle.of(context).style,
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    _onItemTap(0, const HomeView());
                  },
                ),

                // Upload Image option
                ListTile(
                  leading: Icon(
                    Icons.upload_file_outlined,
                    color: _selectedIndex == 1
                        ? const Color(0xFF74BED7)
                        : Colors.black54,
                  ),
                  title: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Upload OPD document',
                          style: DefaultTextStyle.of(context).style,
                        ),
                        WidgetSpan(
                          child: Transform.translate(
                            offset: const Offset(2, -10),
                            // Adjust the position of the superscript
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'AI',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()
                                      ..shader = const LinearGradient(
                                        colors: <Color>[
                                          Colors.blue,
                                          Colors.purple,
                                          Colors.pink,
                                          Colors.red,
                                          Colors.deepOrange,
                                        ],
                                      ).createShader(const Rect.fromLTWH(
                                          0.0, 0.0, 200.0, 70.0)),
                                  ),
                                ),
                                const Icon(
                                  Icons.auto_awesome,
                                  // Gemini-like glitter icon
                                  size: 14,
                                  color: Colors.orange, // Glitter color
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    _onItemTap(1, ImageView(imageController));
                  },
                ),

                ListTile(
                  leading: Icon(
                    Icons.upload_file_outlined,
                    color: _selectedIndex == 2
                        ? const Color(0xFF74BED7)
                        : Colors.black54,
                  ),
                  title: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Upload other documents',
                          style: DefaultTextStyle.of(context).style,
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    _onItemTap(2, ImageUploadWithTextView(imageController));
                  },
                ),
                //if (widget.userRole == 'admin') ...[
                /*ListTile(
                  leading: const Icon(Icons.manage_accounts),
                  title: const Text('Manage Users'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ManageUsersView()),
                    );
                  },
                ),*/
                //],
                ListTile(
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.black54,
                  ),
                  title: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Logout',
                          style: DefaultTextStyle.of(context).style,
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop(); // Close the drawer
                    widget.onLogout(); // Call the logout function
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
