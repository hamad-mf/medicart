import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicart/Controller/Cart%20Screen%20Controller/cart_screen_controller.dart';
import 'package:medicart/Utils/color_constants.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartScreenState = ref.watch(CartScreenStateNotifierProvider);
    final cartController = ref.read(CartScreenStateNotifierProvider.notifier);

    final Stream<QuerySnapshot> _cartStream =
        FirebaseFirestore.instance.collection('cart').snapshots();

    return Scaffold(
      floatingActionButton: StreamBuilder<QuerySnapshot>(
        stream: _cartStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
           return SizedBox.shrink(); // Hide FloatingActionButton if cart is empty
          }

          // Calculate total price
          num totalPrice = 0;
          for (var doc in snapshot.data!.docs) {
            final pricePerItem = doc['price'] as num;
            final itemCount = doc['item_count'] as num;
            totalPrice += pricePerItem * itemCount;
          }

          return SizedBox(
            width: 360, // Custom width
            height: 70, // Custom height
            child: FloatingActionButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Custom border radius
              ),
              backgroundColor: Colors.white, // Custom background color
              onPressed: () {
                print("FloatingActionButton Pressed!");
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
                stream: _cartStream,
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("Something went wrong"),
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
                  if (snapshot.hasData) {
                    return GridView.builder(
                      shrinkWrap:
                          true, // Allow GridView to shrink to fit content
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        childAspectRatio: 3,
                        mainAxisSpacing: 6,
                      ),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final List<QueryDocumentSnapshot<Object?>> cartList =
                            snapshot.data!.docs;

                        final cartItem = cartList[index];
                        final cartItemId = cartItem.id;
                        final itemCount = cartItem['item_count'];
                        final pricePerItem = cartItem['price'];
                        final totalPrice = cartItem['total_price'];

                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          height: 130,
                          decoration: BoxDecoration(
                            color: ColorConstants.cartCardwhite,
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
                                  color: ColorConstants.mainwhite,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Column(
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
                                    children: [
                                      Text(
                                        "₹${totalPrice.toString()}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 50),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            onPressed: () async {
                                              await cartController
                                                  .decrementItemCount(
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
                                            style:
                                                const TextStyle(fontSize: 17),
                                          ),
                                          IconButton(
                                            onPressed: () async {
                                              await cartController
                                                  .incrementItemCount(
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
                                              .doc(cartItemId)
                                              .delete();
                                        },
                                        icon: const Icon(Icons.delete),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
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
