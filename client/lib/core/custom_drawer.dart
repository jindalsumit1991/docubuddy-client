import 'package:flutter/material.dart';
import 'package:image_uploader/controller/image_controller.dart';
import 'package:image_uploader/models/image_model.dart';
import 'package:image_uploader/views/pages/home_view.dart';
import 'package:image_uploader/views/pages/image_view.dart';

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

    return Drawer(
      child: Column(
        children: [
          // Drawer Header for user information
          const UserAccountsDrawerHeader(
            accountName: Text(
              'Sandra Adams',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text('sandra_a88@gmail.com'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/images.jpg'),
            ),
            decoration: BoxDecoration(
              color: Color(0xFF0EA772),
            ),
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
                        ? const Color(0xFF0EA772)
                        : Colors.black54,
                  ),
                  title: const Text('Upload Image'),
                  onTap: () {
                    _onItemTap(1, ImageView(imageController));
                  },
                ),

                // Backups option
                ListTile(
                  leading: Icon(
                    Icons.backup,
                    color: _selectedIndex == 2
                        ? const Color(0xFF0EA772)
                        : Colors.black54,
                  ),
                  title: const Text('Backups'),
                  onTap: () {
                    setState(() {
                      _selectedIndex = 2;
                    });
                    Navigator.pop(context);
                  },
                ),

                // Trash option
                ListTile(
                  leading: Icon(
                    Icons.delete_outline,
                    color: _selectedIndex == 3
                        ? const Color(0xFF0EA772)
                        : Colors.black54,
                  ),
                  title: const Text('Trash'),
                  onTap: () {
                    setState(() {
                      _selectedIndex = 3;
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),

          const Divider(),

          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            title: const Text('Log Out'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
