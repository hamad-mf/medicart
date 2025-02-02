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
        .collection('products')
        .snapshots();
  }

  Future<void> cancelAnItem(String userId, String orderedItemId) async {
    final ordersRef = FirebaseFirestore.instance
        .collection('orders')
        .doc(userId)
        .collection('products');
state = state.copywith(isloading: true);
    //delete that product
    await ordersRef.doc(orderedItemId).delete();
    state = state.copywith(isloading: false);
  }
  
}
