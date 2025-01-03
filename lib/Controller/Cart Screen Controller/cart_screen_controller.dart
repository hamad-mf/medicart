import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicart/Controller/Cart%20Screen%20Controller/cart_screen_state.dart';

final CartScreenStateNotifierProvider =
    StateNotifierProvider<CartScreenController, CartScreenState>(
        (ref) => CartScreenController());

class CartScreenController extends StateNotifier<CartScreenState> {
  CartScreenController() : super(CartScreenState());

 Future<void> incrementItemCount(
    String cartId, String cartItemId, num currentCount, num pricePerItem) async {
  try {
    final newCount = currentCount + 1;
    final newPrice = pricePerItem * newCount;

    // Update the item count and total price in the subcollection
    await FirebaseFirestore.instance
        .collection('cart')
        .doc(cartId)
        .collection('items')
        .doc(cartItemId)
        .update({
      'item_count': newCount,
      'total_price': newPrice,
    });

    print('Item count incremented successfully.');
  } catch (e) {
    print('Error incrementing item count: $e');
  }
}

Future<num> calculateTotalPrice(String cartId) async {
  num totalPrice = 0;

  try {
    // Fetch all items in the subcollection
    QuerySnapshot itemsSnapshot = await FirebaseFirestore.instance
        .collection('cart')
        .doc(cartId)
        .collection('items')
        .get();

    // Sum up the total price for all items
    for (var doc in itemsSnapshot.docs) {
      final itemPrice = doc['total_price'] as num;
      totalPrice += itemPrice;
    }
  } catch (e) {
    print('Error calculating total price: $e');
  }

  return totalPrice;
}



  Future<void> decrementItemCount(
    String cartId, String cartItemId, num currentCount, num pricePerItem) async {
  try {
    if (currentCount > 1) {
      final newCount = currentCount - 1;
      final newPrice = pricePerItem * newCount;

      // Update the item count and total price in the subcollection
      await FirebaseFirestore.instance
          .collection('cart')
          .doc(cartId)
          .collection('items')
          .doc(cartItemId)
          .update({
        'item_count': newCount,
        'total_price': newPrice,
      });

      print('Item count decremented successfully.');
    } else {
      // If count becomes zero, delete the item
      await FirebaseFirestore.instance
          .collection('cart')
          .doc(cartId)
          .collection('items')
          .doc(cartItemId)
          .delete();

      print('Item removed from cart as count reached zero.');
    }
  } catch (e) {
    print('Error decrementing item count or removing item: $e');
  }
}
}