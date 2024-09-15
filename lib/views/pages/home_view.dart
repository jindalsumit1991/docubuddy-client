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
        title: SvgPicture.asset(
          'assets/spotify.svg',
          height: 70,
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Text("Home content Content goes here"),
      ),
    );
  }
}
