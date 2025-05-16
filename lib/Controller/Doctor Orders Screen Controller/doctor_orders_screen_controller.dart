import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicart/Controller/Doctor%20Orders%20Screen%20Controller/doctor_orders_state.dart';


final DoctorOrdersScreenStateNotifierProvider = StateNotifierProvider<
    DoctorOrdersScreenController, DoctorOrdersScreenState>(
  (ref) => DoctorOrdersScreenController(),
);

class DoctorOrdersScreenController
    extends StateNotifier<DoctorOrdersScreenState> {
  DoctorOrdersScreenController() : super(DoctorOrdersScreenState());

 Stream<String?> getStatusStream(String userId, String orderedItemId) {
    return FirebaseFirestore.instance
        .collection('orders_for_doctors')
        .doc(userId)
        .collection('ordered_products')
        .doc(orderedItemId)
        .snapshots()
        .map((snapshot) => snapshot['status'] as String?);
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

  /// Get all orders from all users that are waiting for doctor approval
  Stream<QuerySnapshot> getAllDoctorApprovalWaitingOrdersStream() {
    return FirebaseFirestore.instance
        .collectionGroup('ordered_products') // This looks across all subcollections named 'ordered_products'
        .where('status', isEqualTo: 'Waiting for doctor approval')
        .snapshots();
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
      await FirebaseFirestore.instance
          .collection('orders_for_doctors')
          .doc(userid)
          .collection('ordered_products')
          .doc(ordereditemid)
          .update({
        'status': upddatedStatus,
      });
    } catch (e) {
      log("failed");
      log(e.toString());
    }
    state = state.copywith(isloading: false);
  }




  /// Cancel doctor order by updating the status
  Future<void> cancelDoctorOrder({
    required String userId,
    required String orderedItemId,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders_for_doctors')
          .doc(userId)
          .collection('ordered_products')
          .doc(orderedItemId)
          .update({'status': 'Cancelled'});
    } catch (e) {
      log("Error cancelling order: $e");
    }
  }
}

