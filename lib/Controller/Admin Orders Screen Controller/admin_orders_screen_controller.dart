import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicart/Controller/Admin%20Orders%20Screen%20Controller/admin_orders_screen_state.dart';

final AdminOrdersScreenStateNotifierProvider =
    StateNotifierProvider<AdminOrdersScreenController, AdminOrdersScreenState>(
  (ref) => AdminOrdersScreenController(),
);

class AdminOrdersScreenController
    extends StateNotifier<AdminOrdersScreenState> {
  AdminOrdersScreenController() : super(AdminOrdersScreenState());

  Future<String?> getPrescriptionUrlByCode(String code, String userId) async {
    try {
      final prescriptionsRef = FirebaseFirestore.instance
          .collection('prescriptions')
          .doc(userId)
          .collection('prescription');

      // Query the prescription with the matching code
      final querySnapshot =
          await prescriptionsRef.where('code', isEqualTo: code).limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        final prescriptionData = querySnapshot.docs.first.data();
        return prescriptionData[
            'prescription_url']; // Assuming the URL field is named 'url'
      } else {
        print('No prescription found with the provided code.');
        return null;
      }
    } catch (e) {
      print('Error fetching prescription URL: $e');
      return null;
    }
  }

  Stream<List<DocumentSnapshot>> getAllOrderProductsStream() {
    return FirebaseFirestore.instance
        .collection('orders') // Query the 'orders' collection
        .snapshots()
        .asyncMap((querySnapshot) async {
      List<DocumentSnapshot> products = [];
      for (var orderDoc in querySnapshot.docs) {
        // Query the 'products' subcollection for each order document
        var productsSnapshot =
            await orderDoc.reference.collection('products').get();
        products.addAll(
            productsSnapshot.docs); // Add all product documents to the list
      }
      return products; // Return the list of product documents
    });
  }

  Future<void> changeOrderStatus(
      {required String upddatedStatus,
      required String userid,
     required String code}) async {
    if (upddatedStatus.isEmpty) {
      log("All fields are required.");
      return;
    }
    state = state.copywith(isloading: true);

    try {
      final ordersRef = FirebaseFirestore.instance
          .collection('orders')
          .doc(userid)
          .collection('products');

      final querySnapshot =
          await ordersRef.where('code', isEqualTo: code).limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        final docId = querySnapshot.docs.first.id;
        await ordersRef.doc(docId).update({'status': upddatedStatus});
        log("done");
        state = state.copywith(isloading: false);
      }
      log("succuss");
    } catch (e) {
      log("failed");
      log(e.toString());
    }
    state = state.copywith(isloading: false);
  }
}
