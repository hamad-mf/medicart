import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medicart/Controller/Upload%20Prescription%20Screen%20Controller/upload_prescription_screen_state.dart';

final uploadPrescriptionScreenControllerProvider = StateNotifierProvider<
        UploadPrescriptionScreenController, UploadPrescriptionScreenState>(
    (ref) => UploadPrescriptionScreenController());
final prescriptionCodeProvider = StateProvider<String>((ref) => '');

class UploadPrescriptionScreenController
    extends StateNotifier<UploadPrescriptionScreenState> {
  UploadPrescriptionScreenController() : super(UploadPrescriptionScreenState());

  /// Function to pick an image from the gallery
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      state = state.copyWith(selectedImage: File(image.path));
    }
  }



  /// Function to upload an image to Imgur
  Future<String?> uploadImageToImgur(File imageFile) async {
    const String clientId =
        '71ef9f46d10df0e'; // Replace with your Imgur Client ID
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
        log('Imgur Upload Failed: ${jsonData['data']['error']}');
      }
    } catch (e) {
      log('Error uploading image: $e');
    }
    return null;
  }

  /// Function to save prescription details to Firestore
  Future<void> savePrescriptionToFirestore({
    required String? code,
    required String userId,
    required String productName,
    required String imageUrl,
    required BuildContext context,
  }) async {
    try {
      final prescriptionRef =
          FirebaseFirestore.instance.collection('prescriptions').doc(userId);

      final onePrescription = prescriptionRef.collection('prescription');

      

      // Add a new prescription entry
        await onePrescription.add({
    'code':code,
    'user_id': userId,
    'product_name': productName, // Make sure this matches consistently
    'prescription_url': imageUrl,
    'uploaded_at': FieldValue.serverTimestamp(),
  });
        log('Prescription saved to Firestore.');
      
    } catch (e) {
      log('Error saving prescription to Firestore: $e');
    }
  }

  /// Function to handle the entire process of uploading and saving a prescription
  Future<void> uploadAndSavePrescription({
    required String? code,
    required String userId,
    required String productName,
    required BuildContext context
  }) async {
    final selectedImage = state.selectedImage;
    if (selectedImage == null) {
      log('No image selected.');
      return; // Handle UI notification in the widget.
    }

    state = state.copyWith(isUploading: true);

    try {
      // Upload the selected image to Imgur
      final imageUrl = await uploadImageToImgur(selectedImage);
      if (imageUrl != null) {
        // Save the prescription details to Firestore
        await savePrescriptionToFirestore(
          code:code,
          context: context,
          userId: userId,
          productName: productName,
          imageUrl: imageUrl,
        );

        // Reset the selected image and update the state
        state = state.copyWith(
          uploadedImageUrl: imageUrl,
          selectedImage: null, // Reset the selected image after upload
        );

        log('Prescription uploaded and saved successfully.');
      }
    } catch (e) {
      log('Error during prescription upload: $e');
    } finally {
      state = state.copyWith(isUploading: false);
    }
  }
}
