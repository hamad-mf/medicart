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

    // Recalculate and update the total price in the parent cart document
    final updatedTotalPrice = await calculateTotalPrice(cartId);
    await FirebaseFirestore.instance
        .collection('cart')
        .doc(cartId)
        .update({'total_price': updatedTotalPrice});

    print('Item count incremented and total price updated successfully.');
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
    } else {
      // If count becomes zero, delete the item
      await FirebaseFirestore.instance
          .collection('cart')
          .doc(cartId)
          .collection('items')
          .doc(cartItemId)
          .delete();
    }

    // Recalculate and update the total price in the parent cart document
    final updatedTotalPrice = await calculateTotalPrice(cartId);
    await FirebaseFirestore.instance
        .collection('cart')
        .doc(cartId)
        .update({'total_price': updatedTotalPrice});

    print('Item count decremented and total price updated successfully.');
  } catch (e) {
    print('Error decrementing item count or removing item: $e');
  }
}

Future<void> deleteAllItemsFromCart(String cartId) async {
  try {
    // Fetch all items in the subcollection
    QuerySnapshot itemsSnapshot = await FirebaseFirestore.instance
        .collection('cart')
        .doc(cartId)
        .collection('items')
        .get();

    // Delete each document in the subcollection
    for (var doc in itemsSnapshot.docs) {
      await doc.reference.delete();
    }

    // Set the total price to 0 in the parent cart document
    await FirebaseFirestore.instance
        .collection('cart')
        .doc(cartId)
        .update({'total_price': 0});

    print('All items from cart "$cartId" deleted successfully.');
  } catch (e) {
    print('Error deleting all items from cart: $e');
  }
}

Stream<QuerySnapshot> getUserCartStream(String userId) {
    return FirebaseFirestore.instance
        .collection('cart')
        .doc(userId)
        .collection('items')
        .snapshots();
  }







 Future<void> deleteCartItemAndUpdateTotal(String userId, String cartItemId) async {
    final cartRef = FirebaseFirestore.instance
        .collection('cart')
        .doc(userId)
        .collection('items');

    // Delete the specific item
    await cartRef.doc(cartItemId).delete();

    // Recalculate the total price
    num newTotalPrice = 0;
    final snapshot = await cartRef.get();
    for (var doc in snapshot.docs) {
      newTotalPrice += doc['total_price'] as num;
    }

    // Update Firestore with the new total price (optional)
    await FirebaseFirestore.instance
        .collection('cart')
        .doc(userId)
        .update({'total_price': newTotalPrice});
  }
}