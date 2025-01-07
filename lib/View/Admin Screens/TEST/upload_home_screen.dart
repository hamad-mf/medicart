import 'package:flutter/material.dart';
import 'package:medicart/View/Admin%20Screens/TEST/display_images_screen.dart';
import 'package:medicart/View/Admin%20Screens/TEST/upload_image_screen.dart';

class UploadHomeScreen extends StatelessWidget {
  const UploadHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Imgur Image Uploader')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UploadImageScreen()),
                );
              },
              child: const Text('Upload Image'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DisplayImagesScreen()),
                );
              },
              child: const Text('View Uploaded Images'),
            ),
          ],
        ),
      ),
    );
  }
}