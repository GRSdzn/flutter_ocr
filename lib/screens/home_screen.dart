import 'package:flutter/material.dart';
import 'camera_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TakePictureScreen(),
              ),
            );
          },
          child: const Text('Open Camera'),
        ),
      ),
    );
  }
}
