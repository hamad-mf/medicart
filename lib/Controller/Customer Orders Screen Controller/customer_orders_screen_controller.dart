import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicart/Controller/Customer%20Orders%20Screen%20Controller/customer_orders_screen_state.dart';

final CustomerOrdersScreenStateNotifierProvider = StateNotifierProvider<
    CustomerOrdersScreenController,
    CustomerOrdersScreenState>((ref) => CustomerOrdersScreenController());

class CustomerOrdersScreenController
    extends StateNotifier<CustomerOrdersScreenState> {
  CustomerOrdersScreenController() : super(CustomerOrdersScreenState());

  Stream<QuerySnapshot> getUserOrdersStream(String userid) {
    return FirebaseFirestore.instance
        .collection('orders')
        .doc(userid)
        .collection('ordered_products')
        .snapshots();
  }



Future<void> cancelAnItemDoctorApproval(String userId, String orderedItemId) async {
  final ordersRef = FirebaseFirestore.instance
      .collection('orders_for_doctors')
      .doc(userId)
      .collection('ordered_products');

  final prescriptionRef = FirebaseFirestore.instance
      .collection('prescriptions')
      .doc(userId)
      .collection('prescription');

  state = state.copywith(isloading: true);
  try {
    // Get unique code of ordered item
    final ordersSnapshot = await ordersRef.doc(orderedItemId).get();
    if (ordersSnapshot.exists) {
      final uniqueCode = ordersSnapshot.data()?['code'];

      // Delete the ordered item
      await ordersRef.doc(orderedItemId).delete();

      // Delete prescription with same unique code
      if (uniqueCode != null) {
        final prescriptionSnapshot =
            await prescriptionRef.where('code', isEqualTo: uniqueCode).get();

        for (var doc in prescriptionSnapshot.docs) {
          await prescriptionRef.doc(doc.id).delete();
        }
      }
    }
    state = state.copywith(isloading: false);
  } catch (e) {
    state = state.copywith(isloading: false);
    log("Error deleting doctor approval item or prescription: $e");
  }
}



//newly added
Stream<QuerySnapshot> getUserOrdersDoctorApprovelWaitingStream(String userid) {
    return FirebaseFirestore.instance
        .collection('orders_for_doctors')
        .doc(userid)
        .collection('ordered_products')
        .snapshots();
  }

  Future<void> cancelAnItem(String userId, String orderedItemId) async {
    final ordersRef = FirebaseFirestore.instance
        .collection('orders')
        .doc(userId)
        .collection('ordered_products');
    final prescriptionRef = FirebaseFirestore.instance
        .collection('prescriptions')
        .doc(userId)
        .collection('prescription');

    state = state.copywith(isloading: true);
    try {
      //get unique code of ordereditem
      final ordersSnapshot = await ordersRef.doc(orderedItemId).get();
      if (ordersSnapshot.exists) {
        final uniqueCode = ordersSnapshot.data()?['code'];

        //delete the ordered item
        await ordersRef.doc(orderedItemId).delete();

        //delete prescription with same unique code
        if (uniqueCode != null) {
          final prescriptionSnapshot =
              await prescriptionRef.where('code', isEqualTo: uniqueCode).get();

          for (var doc in prescriptionSnapshot.docs) {
            await prescriptionRef.doc(doc.id).delete();
          }
        }
      }
      state = state.copywith(isloading: false);
    } catch (e) {
      state = state.copywith(isloading: false);

      log("Error deleting item or prescription: $e");
    }
  }
}
