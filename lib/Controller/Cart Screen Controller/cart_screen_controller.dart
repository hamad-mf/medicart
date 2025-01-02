import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicart/Controller/Cart%20Screen%20Controller/cart_screen_state.dart';

final CartScreenStateNotifierProvider =
    StateNotifierProvider<CartScreenController, CartScreenState>(
        (ref) => CartScreenController());

class CartScreenController extends StateNotifier<CartScreenState> {
  CartScreenController() : super(CartScreenState());

  Future<void> incrementItemCount(
      String cartItemId, int currentCount, num pricePerItem) async {
    try {
      final newCount = currentCount + 1;
      final newPrice = pricePerItem * newCount;

      // Update count and total price in Firebase
      await FirebaseFirestore.instance
          .collection('cart')
          .doc(cartItemId)
          .update({
        'item_count': newCount,
        'total_price': newPrice,
      });

      // Update the UI state
      state = state.copywith(newCount: newCount);
    } catch (e) {
      print('Error incrementing item count: $e');
    }
  }

Future<num> calculateTotalPrice() async {
  num totalPrice = 0;

  try {
    QuerySnapshot cartSnapshot = await FirebaseFirestore.instance
        .collection('cart')
        .get(); // Fetch all items in the cart

    for (var doc in cartSnapshot.docs) {
      final price = doc['price'] as num;
      final count = doc['item_count'] as num;
      totalPrice += price * count; // Calculate total price for each item
    }
  } catch (e) {
    print("Error calculating total price: $e");
  }

  return totalPrice;
}



  Future<void> decrementItemCount(
      String cartItemId, int currentCount, num pricePerItem) async {
    try {
      if (currentCount > 1) {
        final newCount = currentCount - 1;
        final newPrice = pricePerItem * newCount;

        // Decrement count and update total price in Firebase
        await FirebaseFirestore.instance
            .collection('cart')
            .doc(cartItemId)
            .update({
          'item_count': newCount,
          'total_price': newPrice,
        });

        // Update the UI state
        state = state.copywith(newCount: newCount);
      } else {
        // If count becomes zero, delete the item
        await FirebaseFirestore.instance.collection('cart').doc(cartItemId).delete();
        print('Item removed from cart as count reached zero');
      }
    } catch (e) {
      print('Error decrementing item count or removing item: $e');
    }
  }
}