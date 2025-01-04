import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicart/Controller/Cart%20Screen%20Controller/cart_screen_controller.dart';
import 'package:medicart/Utils/color_constants.dart';
import 'package:medicart/View/Customer%20Screens/Product%20Screen/product_screen.dart';

class CartScreen extends ConsumerWidget {
  final String userId;

  const CartScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final cartController = ref.read(CartScreenStateNotifierProvider.notifier);

    final userCartStream = cartController.getUserCartStream(userId);


    return Scaffold(
      floatingActionButton: StreamBuilder<QuerySnapshot>(
        stream: userCartStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const SizedBox.shrink();
          }

          num totalPrice = 0;
          for (var doc in snapshot.data!.docs) {
            totalPrice += doc['total_price'] as num;
          }

          return SizedBox(
            width: screenWidth * 0.9,
            height: screenHeight * 0.09,
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
                  SizedBox(width: screenWidth * 0.04),
                  Flexible(
                    child: Text(
                      "₹${totalPrice.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: screenWidth * 0.35,
                    height: screenHeight * 0.049,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "Checkout",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.04),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.04),
                ],
              ),
            ),
          );
        },
      ),
      appBar: AppBar(
        title: const Text("Cart"),
        actions: [
          IconButton(
              onPressed: () async {
                await CartScreenController().deleteAllItemsFromCart(userId);
              },
              icon: Icon(Icons.delete_forever_sharp))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
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
                        margin:
                            EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.02),
                        height: screenHeight * 0.19,
                        decoration: BoxDecoration(
                          color: ColorConstants.cartCardwhite,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProductScreen(
                                            isPresNeeded: cartItem[
                                                "requiresPrescription"],
                                            product_name:
                                                cartItem["product_name"],
                                            image_url: cartItem["image_url"],
                                            category: cartItem["category"],
                                            details: cartItem["details"],
                                            price: cartItem["price"],
                                            stocks: cartItem["stocks"],
                                            usage: cartItem["usage"])));
                              },
                              child: Container(
                                width: screenWidth * 0.22,
                                height: screenHeight * 0.10,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(cartItem['image_url']),
                                    fit: BoxFit.contain,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  color: ColorConstants.mainwhite,
                                ),
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.04),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: screenHeight * 0.02),
                                  Text(
                                    cartItem['product_name'],
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.05,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  SizedBox(height: screenHeight * 0.02),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          "₹${totalPrice.toStringAsFixed(2)}",
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.05,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
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
                                            icon: Icon(
                                              Icons.remove,
                                              size: screenWidth * 0.07,
                                            ),
                                          ),
                                          Text(
                                            itemCount.toString(),
                                            style: TextStyle(
                                                fontSize: screenWidth * 0.05),
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
                                            icon: Icon(
                                              Icons.add,
                                              size: screenWidth * 0.07,
                                            ),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          await cartController
                                              .deleteCartItemAndUpdateTotal(
                                                  userId, cartItemId);
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
