import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicart/Controller/Product%20Adding%20Screen%20Controller/product_adding_screen_state.dart';
import 'package:medicart/Utils/app_utils.dart';

final ProductAddingScreenStateNotifierProvider =
    StateNotifierProvider((ref) => ProductAddingScreenController());

class ProductAddingScreenController
    extends StateNotifier<ProductAddingScreenState> {
  ProductAddingScreenController() : super(ProductAddingScreenState());

void toggleRequiresPrescription() {
    state = state.copywith(
      requiresPrescription: !state.requiresPrescription,
    );
  }


void setRequiresPrescription(bool value) {
    state = state.copywith(
      requiresPrescription: value,
    );
  }



  Future<void> onProductAdd({
    required String category,
    required String details,
    required String image_url,
    required String product_name,
    required String usage,
    required bool requiresPrescription,
    required num price,
    required num stocks,
    required BuildContext context,
  }) async {
    if (category.isNotEmpty &&
        details.isNotEmpty &&
        image_url.isNotEmpty &&
        product_name.isNotEmpty &&
        usage.isNotEmpty) {
      state = state.copywith(isloading: true);

      try {
        //check for duplicate products

        final QuerySnapshot = await FirebaseFirestore.instance
            .collection('products')
            .where('product_name', isEqualTo: product_name)
            .get();

        if (QuerySnapshot.docs.isEmpty) {
          //product not exists, add it
          await FirebaseFirestore.instance.collection('products').add({
            'category': category,
            'details': details,
            'image_url': image_url,
            'price': price,
            'product_name': product_name,
            'stocks': stocks,
            'usage': usage,
            'requiresPrescription': requiresPrescription
          });

          AppUtils.showSnackbar(
              context: context,
              message: "Added successfully",
              bgcolor: Colors.green);
        } else {
          AppUtils.showSnackbar(
              context: context, message: "product already added");
        }
      } catch (e) {
        log(e.toString());
        AppUtils.showSnackbar(context: context, message: "an error occured");
      }
      state = state.copywith(isloading: false);
    } else {
      AppUtils.showSnackbar(context: context, message: "fields cannot be empty");
    }
  }
}
