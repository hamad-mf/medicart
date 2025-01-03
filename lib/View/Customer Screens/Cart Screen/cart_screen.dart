import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicart/Controller/Cart%20Screen%20Controller/cart_screen_controller.dart';
import 'package:medicart/Utils/color_constants.dart';

class CartScreen extends ConsumerWidget {
  final String userId; // User ID to identify the user's cart
  
  const CartScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartController = ref.read(CartScreenStateNotifierProvider.notifier);

    // Stream for the specific user's cart
    final Stream<QuerySnapshot> userCartStream = FirebaseFirestore.instance
        .collection('cart')
        .doc(userId)
        .collection('items')
        .snapshots();

    return Scaffold(
      floatingActionButton: StreamBuilder<QuerySnapshot>(
        stream: userCartStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const SizedBox.shrink(); // Hide if no items in cart
          }

          // Calculate the total price dynamically
          num totalPrice = 0;
          for (var doc in snapshot.data!.docs) {
            totalPrice += doc['total_price'] as num;
          }

          return SizedBox(
            width: 360,
            height: 70,
            child: FloatingActionButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              backgroundColor: Colors.white,
              onPressed: () {
                print("Proceed to Checkout with Total Price: ₹$totalPrice");
              },
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Text(
                    "₹${totalPrice.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 130,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        "Checkout",
                        style: TextStyle(color: Colors.white, fontSize: 19),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
            ),
          );
        },
      ),
      appBar: AppBar(
        title: const Text("Cart"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder(
                stream: userCartStream,
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("Something went wrong. Please try again."),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Column(
                        children: [
                          SizedBox(height: 300),
                          Text(
                            "No items in the cart",
                            style: TextStyle(fontSize: 17),
                          ),
                        ],
                      ),
                    );
                  }

                  // Display cart items
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final cartItem = snapshot.data!.docs[index];
                      final cartItemId = cartItem.id;
                      final itemCount = cartItem['item_count'] as num;
                      final pricePerItem = cartItem['price_per_item'] as num;
                      final totalPrice = cartItem['total_price'] as num;

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: 130,
                        decoration: BoxDecoration(
                          color: ColorConstants.cartCardwhite,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(cartItem['image_url']),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                color: ColorConstants.mainwhite,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 15),
                                  Text(
                                    cartItem['product_name'],
                                    style: const TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "₹${totalPrice.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () async {
                                              await cartController
                                                  .decrementItemCount(
                                                userId,
                                                cartItemId,
                                                itemCount,
                                                pricePerItem,
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.remove,
                                              size: 25,
                                            ),
                                          ),
                                          Text(
                                            itemCount.toString(),
                                            style: const TextStyle(
                                                fontSize: 17),
                                          ),
                                          IconButton(
                                            onPressed: () async {
                                              await cartController
                                                  .incrementItemCount(
                                                userId,
                                                cartItemId,
                                                itemCount,
                                                pricePerItem,
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.add,
                                              size: 25,
                                            ),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          await FirebaseFirestore.instance
                                              .collection('cart')
                                              .doc(userId)
                                              .collection('items')
                                              .doc(cartItemId)
                                              .delete();
                                        },
                                        icon: const Icon(Icons.delete),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 90),
            ],
          ),
        ),
      ),
    );
  }
}
