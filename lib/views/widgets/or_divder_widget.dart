import 'package:flutter/material.dart';

class OrDivderWidget extends StatelessWidget {
  const OrDivderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: Colors.grey,
          ),
        ),
        const Text(
          " OR ",
          style: TextStyle(color: Colors.grey),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
