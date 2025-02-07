import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicart/Controller/Place%20Oder%20Controller/place_order_state.dart';

final PlaceOrderStateNotifierProvider =
    StateNotifierProvider<PlaceOrderController, PlaceOrderState>(
        (ref) => PlaceOrderController());

class PlaceOrderController extends StateNotifier<PlaceOrderState> {
  PlaceOrderController() : super(PlaceOrderState());

  Future<void> onPlaceOrder({
    required String status,
    required String payment_method,
    required String img_url,
    required String userId,
    required String name,
    required String phn,
    required String city,
    required String State,
    required String country,
    required String pin_code,
    required String street_address,
    required num amount,
    required String product_name,
    required String qnt,
    required String? code,
  }) async {
    //check empty
    if (name.isEmpty ||
        payment_method.isEmpty ||
        phn.isEmpty ||
        img_url.isEmpty ||
        product_name.isEmpty ||
        status.isEmpty ||
        State.isEmpty ||
        city.isEmpty ||
        country.isEmpty ||
        pin_code.isEmpty ||
        product_name.isEmpty) {
      log("All fields are required.");
      return;
    }

    state = state.copywith(isloading: true);

    try {
      // // Reference to the user's cart document
      // final cartRef = FirebaseFirestore.instance.collection('cart').doc(userId);
      // Reference to the user's orders document
      final ordersRef =
          FirebaseFirestore.instance.collection('orders').doc(userId);
      // // Reference to the user's cart items subcollection
      // final itemsRef = cartRef.collection('items');
// Reference to the user's orders products subcollection
      final productRef = ordersRef.collection('products');

      await productRef.add({
        'status': status,
        'code': code,
        'payment_method': payment_method,
        'img_url': img_url,
        'userid': userId,
        'name': name,
        'phone_number': phn,
        'city': city,
        'state': State,
        'country': country,
        'pin_code': pin_code,
        'street_address': street_address,
        'amount': amount,
        'quantity': qnt,
        'product_name': product_name
      });

      log("order success");
    } catch (e) {
      log(e.toString());
    }
    state = state.copywith(isloading: false);
  }
}
