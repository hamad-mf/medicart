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
    if (category.isNotEmpty &&
        details.isNotEmpty &&
        image_url.isNotEmpty &&
        product_name.isNotEmpty &&
        usage.isNotEmpty) {
      state = state.copywith(isloading: true);

      try {
        final QuerySnapshot = await FirebaseFirestore.instance
            .collection('cart')
            .where('product_name', isEqualTo: product_name)
            .get();

        if (QuerySnapshot.docs.isEmpty) {
          //if product is not in the cart , add it

          await FirebaseFirestore.instance.collection('cart').add({
            'total_price':total_price,
            'category': category,
            'details': details,
            'image_url': image_url,
            'price': price,
            'product_name': product_name,
            'stocks': stocks,
            'usage': usage,
            'requiresPrescription': requiresPrescription,
            'item_count': itemcount
          });
          AppUtils.showSnackbar(
              context: context,
              message: "Added to cart",
              bgcolor: Colors.green);
        } else {
          AppUtils.showSnackbar(
              context: context,
              message: "item Already exists in the cart",
              bgcolor: Colors.red);
        }
      } catch (e) {
        log(e.toString());
        AppUtils.showSnackbar(
            context: context, message: "An error occured", bgcolor: Colors.red);
      }
      state = state.copywith(isloading: false);
    } else {
      AppUtils.showSnackbar(context: context, message: "");
    }
  }
}
