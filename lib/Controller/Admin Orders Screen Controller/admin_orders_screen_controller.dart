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






 Future<String?> updateTheStatus(String phone_number, String userId) async {
    try {
      final prescriptionsRef = FirebaseFirestore.instance
          .collection('orders')
          .doc(userId)
          .collection('ordered_products');

      // Query the prescription with the matching code
      final querySnapshot =
          await prescriptionsRef.where('phone_number', isEqualTo: phone_number).limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        final prescriptionData = querySnapshot.docs.first.data();
        return prescriptionData[
            'status']; 
      } else {
        print('Not retrieved');
        return null;
      }
    } catch (e) {
      print('Error fetching status: $e');
      return null;
    }
  }

Stream<DocumentSnapshot> getstatus(String userId) {
  return FirebaseFirestore.instance
      .collection('orders')
      .doc(userId)
      .snapshots();
}

  Stream<List<DocumentSnapshot>> getAllOrderProductsStream() {
    return FirebaseFirestore.instance
        .collectionGroup(
            'ordered_products') // Query all 'products' subcollections at once
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs; // Return all product documents
    });
  }

  Future<void> changeOrderStatus(
      {required String upddatedStatus,
      required String userid,
      }) async {
    if (upddatedStatus.isEmpty) {
      log("All fields are required.");
      return;
    }
    state = state.copywith(isloading: true);

    try {
     await FirebaseFirestore.instance
        .collection('orders')
        .doc(userid)
        .update({'status': upddatedStatus});
    } catch (e) {
      log("failed");
      log(e.toString());
    }
    state = state.copywith(isloading: false);
  }
}
