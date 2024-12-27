import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medicart/Utils/app_utils.dart';

class AddToCartController with ChangeNotifier {
  bool isLoading = false;

  Future<void> onAddtoCart({
    required String category,
    required String details,
    required String image_url,
    required String product_name,
    required String usage,
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
      isLoading = true;
      notifyListeners();
      try {
        final QuerySnapshot = await FirebaseFirestore.instance
            .collection('cart')
            .where('product_name', isEqualTo: product_name)
            .get();

        if (QuerySnapshot.docs.isEmpty) {
          //if products is not in the cart add it
          await FirebaseFirestore.instance.collection('cart').add({
            'category': category,
            'details': details,
            'image_url': image_url,
            'price': price,
            'product_name': product_name,
            'stocks': stocks,
            'usage': usage,
            'requiresPrescription': requiresPrescription,
            'item_count':itemcount
          });
          AppUtils.showSnackbar(
              context: context,
              message: "Added to cart",
              bgcolor: Colors.green);
        } else {
          AppUtils.showSnackbar(
              context: context,
              message: "Already exist in the cart",
              bgcolor: Colors.red);
        }
      } catch (e) {
        print(e);
        AppUtils.showSnackbar(
            context: context, message: "An error occured", bgcolor: Colors.red);
      }
      isLoading = false;
      notifyListeners();
    } else {
      AppUtils.showSnackbar(context: context, message: "");
    }
  }
}
