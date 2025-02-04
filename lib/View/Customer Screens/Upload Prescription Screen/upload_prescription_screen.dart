

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicart/Controller/Add%20To%20Cart%20Controller/add_to_cart_controller.dart';
import 'package:medicart/Controller/Add%20To%20Cart%20Controller/add_to_cart_state.dart';
import 'package:medicart/Controller/Upload%20Prescription%20Screen%20Controller/upload_prescription_screen_controller.dart';
import 'package:medicart/View/Global%20Widgets/custom_button.dart';

// ignore: must_be_immutable
class UploadPrescriptionScreen extends ConsumerWidget {
  String user_id;
  num total_price;
  String category;
  String details;
  String image_url;
  String usage;
  num price;
  num stocks;
  bool requiresPrescription;
  num itemcount;
  BuildContext context;
  String ProductName;

  UploadPrescriptionScreen(
      {super.key,
      required this.ProductName,
      required this.category,
      required this.context,
      required this.details,
      required this.image_url,
      required this.itemcount,
      required this.price,
      required this.requiresPrescription,
      required this.stocks,
      required this.total_price,
      required this.user_id,
      required this.usage});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uploadState = ref.watch(uploadPrescriptionScreenControllerProvider);
    final uploadController =
        ref.read(uploadPrescriptionScreenControllerProvider.notifier);

    final addtocartstate =
        ref.watch(AddToCartScreenStateNotifierProvider) as AddToCartState;

    return Scaffold(
      appBar: AppBar(title: const Text('Upload Image')),
      body: Stack(
        children: [
          Padding(
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
                            ? null
                            : () async {
                                await uploadController
                                    .uploadAndSavePrescription(
                                  userId:
                                      FirebaseAuth.instance.currentUser!.uid,
                                  productName: ProductName,
                                  context: context,
                                );

                                if (uploadState.uploadedImageUrl != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Prescription uploaded successfully!'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              },
                        child: const Text('Upload and Save'),
                      ),
                if (uploadState.uploadedImageUrl != null)
                  customButton(
                    onPressed: () async {
                      bool isAdded = await ref
                          .read(AddToCartScreenStateNotifierProvider.notifier)
                          .onAddToCart(
                            userId: FirebaseAuth.instance.currentUser!.uid,
                            total_price: price,
                            category: category,
                            details: details,
                            image_url: image_url,
                            product_name: ProductName,
                            usage: usage,
                            price: price,
                            stocks: stocks,
                            requiresPrescription: requiresPrescription,
                            itemcount: 1,
                            context: context,
                          );

                      if (isAdded) {
                        uploadState.selectedImage = null;

                        Navigator.pop(context);
                      }
                    },
                    text: "Add to cart",
                  ),
              ],
            ),
          ),
          if (addtocartstate.isloading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
