import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CartScreenController with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
 

  Future<void> incrementCount(
      String docId, int currentCount, num currentPrice) async {
    
    await _firestore.collection('cart').doc(docId).update(
        {'item_count': currentCount + 1, 'price': currentPrice ++});
  }

  Future<void> decrementCount(
      String docId, int currentCount, num currentPrice) async {
    if (currentCount > 1) {
      await _firestore.collection('cart').doc(docId).update({
        'item_count': currentCount - 1,
        'price': currentPrice - currentPrice
      });
    } else if (currentCount == 1) {
      await removeItem(docId);
    }
  }

  Future<void> removeItem(String docId) async {
    await _firestore.collection('cart').doc(docId).delete();
  }
}
