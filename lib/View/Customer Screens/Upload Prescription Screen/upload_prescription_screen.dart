
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicart/Controller/Upload%20Prescription%20Screen%20Controller/upload_prescription_screen_controller.dart';

// ignore: must_be_immutable
class UploadPrescriptionScreen extends ConsumerWidget {
  String ProductName;
   UploadPrescriptionScreen({super.key,required this.ProductName});

  @override
  Widget build(BuildContext context, WidgetRef ref){
    String uid;
  
      final User? user =
          FirebaseAuth.instance.currentUser; // Get the current user
        uid = user!.uid;
     
      
    final uploadState = ref.watch(uploadPrescriptionScreenControllerProvider);
    final uploadController = ref.read(uploadPrescriptionScreenControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Upload Image')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: uploadController.pickImage,
              child: const Text('Pick Image'),
            ),
            if (uploadState.selectedImage != null)
              Image.file(uploadState.selectedImage!, height: 200),
            const SizedBox(height: 16),
            uploadState.isUploading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
  onPressed: uploadState.isUploading
      ? null // Disable the button while uploading
      : () async {
          await uploadController.uploadAndSavePrescription(userId: uid,productName: ProductName,context: context);

          // Show success message after the upload
          if (uploadState.uploadedImageUrl != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Prescription uploaded successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
  child: uploadState.isUploading
      ? const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        )
      : const Text('Upload and Save'),
),

            if (uploadState.uploadedImageUrl != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  'Image URL: ${uploadState.uploadedImageUrl}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.green),
                ),
              ),
          ],
        ),
      ),
    );
  }

}
