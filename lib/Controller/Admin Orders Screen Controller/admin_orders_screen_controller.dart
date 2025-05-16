import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicart/Controller/Admin%20Orders%20Screen%20Controller/admin_orders_screen_state.dart';
import 'package:rxdart/rxdart.dart';

final AdminOrdersScreenStateNotifierProvider =
    StateNotifierProvider<AdminOrdersScreenController, AdminOrdersScreenState>(
  (ref) => AdminOrdersScreenController(),
);

class AdminOrdersScreenController
    extends StateNotifier<AdminOrdersScreenState> {
  AdminOrdersScreenController() : super(AdminOrdersScreenState());
  Stream<String?> getStatusStream(String userId, String orderedItemId) async* {
    // First try the regular orders collection
    final ordersDoc = await FirebaseFirestore.instance
        .collection('orders')
        .doc(userId)
        .collection('ordered_products')
        .doc(orderedItemId)
        .get();

    if (ordersDoc.exists) {
      yield* FirebaseFirestore.instance
          .collection('orders')
          .doc(userId)
          .collection('ordered_products')
          .doc(orderedItemId)
          .snapshots()
          .map((snap) => snap['status'] as String?);
    } else {
      // If not found in orders, try orders_for_doctors
      yield* FirebaseFirestore.instance
          .collection('orders_for_doctors')
          .doc(userId)
          .collection('ordered_products')
          .doc(orderedItemId)
          .snapshots()
          .map((snap) => snap['status'] as String?);
    }
  }

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

  Stream<List<DocumentSnapshot>> getstatus(String userId) {
    return FirebaseFirestore.instance
        .collectionGroup('ordered_products')
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs;
    });
  }

  Stream<List<DocumentSnapshot>> getAllOrderProductsStream() {
    // Create a set to track unique document IDs
    final Set<String> seenDocIds = {};

    return FirebaseFirestore.instance
        .collectionGroup('ordered_products')
        .snapshots()
        .map((querySnapshot) {
      // Filter out duplicates
      final uniqueDocs = querySnapshot.docs.where((doc) {
        if (seenDocIds.contains(doc.id)) {
          return false; // Skip if we've seen this doc before
        }
        seenDocIds.add(doc.id);
        return true;
      }).toList();

      return uniqueDocs;
    });
  }

  Future<void> changeOrderStatus({
    required String upddatedStatus,
    required String userid,
    required String ordereditemid,
  }) async {
    if (upddatedStatus.isEmpty) {
      log("All fields are required.");
      return;
    }
    state = state.copywith(isloading: true);

    try {
      // First check if the document exists in orders collection
      final ordersRef = FirebaseFirestore.instance
          .collection('orders')
          .doc(userid)
          .collection('ordered_products')
          .doc(ordereditemid);

      final ordersDoc = await ordersRef.get();

      if (ordersDoc.exists) {
        // Update in orders collection
        log("Updating status in orders collection");
        await ordersRef.update({'status': upddatedStatus});
      } else {
        log("Updating status in orders_for_doctors collection");
        // If not found in orders, update in orders_for_doctors
        final doctorsOrdersRef = FirebaseFirestore.instance
            .collection('orders_for_doctors')
            .doc(userid)
            .collection('ordered_products')
            .doc(ordereditemid);

        await doctorsOrdersRef.update({'status': upddatedStatus});
      }
    } catch (e) {
      log("Failed to update status");
      log(e.toString());
    }
    state = state.copywith(isloading: false);
  }
}
