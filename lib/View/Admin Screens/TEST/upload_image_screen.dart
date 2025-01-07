import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  File? _selectedImage;
  bool _isUploading = false;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<String?> uploadImageToImgur(File imageFile) async {
    const String clientId = '71ef9f46d10df0e'; // Replace with your Imgur Client ID
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.imgur.com/3/image'),
      );

      request.headers['Authorization'] = 'Client-ID $clientId';

      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );

      final response = await request.send();

      final responseData = await http.Response.fromStream(response);
      final jsonData = jsonDecode(responseData.body);

      if (jsonData['success'] == true) {
        return jsonData['data']['link'];
      } else {
        print('Imgur Upload Failed: ${jsonData['data']['error']}');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
    return null;
  }

  Future<void> saveImageUrlToFirestore(String imageUrl) async {
    try {
      await FirebaseFirestore.instance
          .collection('images')
          .add({'url': imageUrl});
      print('Image URL saved to Firestore.');
    } catch (e) {
      print('Error saving URL to Firestore: $e');
    }
  }

  Future<void> uploadAndSaveImage() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image first!')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    String? imageUrl = await uploadImageToImgur(_selectedImage!);

    if (imageUrl != null) {
      await saveImageUrlToFirestore(imageUrl);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image uploaded and URL saved!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload image.')),
      );
    }

    setState(() {
      _isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Image')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: pickImage,
              child: const Text('Pick Image'),
            ),
            if (_selectedImage != null)
              Image.file(_selectedImage!, height: 200),
            const SizedBox(height: 16),
            _isUploading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: uploadAndSaveImage,
                    child: const Text('Upload and Save'),
                  ),
          ],
        ),
      ),
    );
  }
}
