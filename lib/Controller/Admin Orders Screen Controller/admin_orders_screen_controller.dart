import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicart/Controller/Admin%20Orders%20Screen%20Controller/admin_orders_screen_state.dart';

final AdminOrdersScreenStateNotifierProvider = StateNotifierProvider<AdminOrdersScreenController,AdminOrdersScreenState>((ref) => AdminOrdersScreenController(),);


class AdminOrdersScreenController
    extends StateNotifier<AdminOrdersScreenState> {
  AdminOrdersScreenController() : super(AdminOrdersScreenState());






Stream<List<DocumentSnapshot>> getAllOrderProductsStream() {
  return FirebaseFirestore.instance
      .collection('orders') // Query the 'orders' collection
      .snapshots()
      .asyncMap((querySnapshot) async {
    List<DocumentSnapshot> products = [];
    for (var orderDoc in querySnapshot.docs) {
      // Query the 'products' subcollection for each order document
      var productsSnapshot = await orderDoc.reference.collection('products').get();
      products.addAll(productsSnapshot.docs); // Add all product documents to the list
    }
    return products; // Return the list of product documents
  });
}
}
