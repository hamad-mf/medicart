

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medicart/Utils/app_utils.dart';



class ProductAddingScreenController with ChangeNotifier {
  bool isLoading = false;

 

  Future<void> onProductadd({
    required String category,
    required String details,
    required String image_url,
    required String product_name,
    required String usage,
    required num price,
    required num stocks,
    required BuildContext context,
  }) async {
    if (category.isNotEmpty && details.isNotEmpty && image_url.isNotEmpty && product_name.isNotEmpty && usage.isNotEmpty ) {
      isLoading = true;
      notifyListeners();

      try {
        //check for duplicate product

        final QuerySnapshot = await FirebaseFirestore.instance
            .collection('products')
            .where('product_name', isEqualTo: product_name)
            .get();

        if (QuerySnapshot.docs.isEmpty) {
          //product not exist add new product
          await FirebaseFirestore.instance
              .collection('products')
              .add({'category': category, 'details': details, 'image_url': image_url, 'price': price, 'product_name': product_name, 'stocks': stocks, 'usage': usage, });

          AppUtils.showSnackbar(
              context: context,
              message: "Added successfully",
              bgcolor: Colors.green);

          //navigate to login screen

          // Navigator.pushAndRemoveUntil(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => LoginScreen(),
          //     ),(route) => false,
          //     );
        } else {
          //email already registered
          AppUtils.showSnackbar(
              context: context,
              message: "Product already added",
              bgcolor: Colors.red);
        }
      } catch (e) {
        print(e);
        AppUtils.showSnackbar(context: context, message: "an error occured");
      }
      isLoading = false;
      notifyListeners();
    }else{
      AppUtils.showSnackbar(context: context, message: "Fields cannot be empty");
    }
  }
}
