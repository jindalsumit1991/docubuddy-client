import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_uploader/core/custom_drawer.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
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
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipOval(
              child: SizedBox(
                height: 30,
                width: 30,
                child: Image.asset(
                  'assets/logo.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 8),
            Text(
              'DocuBrain',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
        body: const Center(
          child: Text("Manage your documents here"),
       ),

    );
  }
}
