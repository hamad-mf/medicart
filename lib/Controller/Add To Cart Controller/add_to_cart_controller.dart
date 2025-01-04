import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicart/Controller/Add%20To%20Cart%20Controller/add_to_cart_state.dart';
import 'package:medicart/Utils/app_utils.dart';

final AddToCartScreenStateNotifierProvider =
    StateNotifierProvider((ref) => AddToCartController());

class AddToCartController extends StateNotifier<AddToCartState> {
  AddToCartController() : super(AddToCartState());
Future<void> onAddToCart({
  required String userId, // Added to associate the cart with a user
  required String category,
  required String details,
  required String image_url,
  required String product_name,
  required String usage,
  required num total_price,
  required num price,
  required num stocks,
  required bool requiresPrescription,
  required num itemcount,
  required BuildContext context,
}) async {
  // Check for empty fields
  if (category.isEmpty ||
      details.isEmpty ||
      image_url.isEmpty ||
      product_name.isEmpty ||
      usage.isEmpty) {
    AppUtils.showSnackbar(
        context: context, message: "All fields are required.");
    return;
  }

  state = state.copywith(isloading: true);

  try {
    // Reference to the user's cart document
    final cartRef = FirebaseFirestore.instance.collection('cart').doc(userId);

    // Reference to the user's cart items subcollection
    final itemsRef = cartRef.collection('items');

    // Check if the product already exists in the user's cart
    final existingItemQuery = await itemsRef
        .where('product_name', isEqualTo: product_name)
        .get();

    if (existingItemQuery.docs.isEmpty) {
      // Add new item to the cart
      await itemsRef.add({
        'price_per_item': price,
        'total_price': total_price,
        'category': category,
        'details': details,
        'image_url': image_url,
        'price': price,
        'product_name': product_name,
        'stocks': stocks,
        'usage': usage,
        'requiresPrescription': requiresPrescription,
        'item_count': itemcount,
      });

      // Recalculate the total price for the cart
      QuerySnapshot itemsSnapshot = await itemsRef.get();
      num updatedTotalPrice = 0;
      for (var doc in itemsSnapshot.docs) {
        updatedTotalPrice += (doc['total_price'] as num);
      }

      // Update the total price in the main cart document
      await cartRef.set({
        'total_price': updatedTotalPrice,
      }, SetOptions(merge: true)); // Merge ensures that no other fields in the cart document are overwritten.

      AppUtils.showSnackbar(
          context: context,
          message: "Item added to cart.",
          bgcolor: Colors.green);
    } else {
      // Item already exists in the cart
      AppUtils.showSnackbar(
          context: context,
          message: "Item already exists in the cart.",
          bgcolor: Colors.red);
    }
  } catch (e) {
    log(e.toString());
    AppUtils.showSnackbar(
        context: context,
        message: "An error occurred. Please try again.",
        bgcolor: Colors.red);
  }

  state = state.copywith(isloading: false);
}

}
