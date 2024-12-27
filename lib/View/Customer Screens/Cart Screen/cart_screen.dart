import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medicart/Controller/cart_screen_controller.dart';

import 'package:medicart/Utils/color_constants.dart';


class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartScreenController itemupdater = CartScreenController();

  final Stream<QuerySnapshot> _cartStream =
      FirebaseFirestore.instance.collection('cart').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
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
                      return Center(
                        child: Text("Something went wrong"),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 300,
                            ),
                            Text(
                              "no items in the cart",
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
                        physics: NeverScrollableScrollPhysics(),

                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1, childAspectRatio: 3),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final List<QueryDocumentSnapshot<Object?>> cartlist =
                              snapshot.data!.docs;

                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            height: 130,
                            decoration: BoxDecoration(
                                color: ColorConstants.cartCardwhite),
                            child: Row(
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              cartlist[index]["image_url"]),
                                          fit: BoxFit.cover),
                                      color: ColorConstants.mainwhite),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      cartlist[index]["product_name"],
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "₹${cartlist[index]["price"].toString()}",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          width: 50,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                                onPressed: () async {
                                                  await itemupdater
                                                      .decrementCount(
                                                          cartlist[index].id,
                                                          cartlist[index]
                                                              ["item_count"],
                                                              cartlist[index]["price"]
                                                        );
                                                },
                                                icon: Icon(
                                                  Icons.remove,
                                                  size: 25,
                                                )),
                                            Text(
                                              cartlist[index]["item_count"]
                                                  .toString(),
                                              style: TextStyle(fontSize: 17),
                                            ),
                                            IconButton(
                                                onPressed: () async {
                                                  await itemupdater
                                                      .incrementCount(
                                                          cartlist[index].id,
                                                          cartlist[index]
                                                              ["item_count"],
                                                              cartlist[index]["price"],snapshot,index);
                                                },
                                                icon: Icon(
                                                  Icons.add,
                                                  size: 25,
                                                )),
                                          ],
                                        ),
                                        IconButton(
                                            onPressed: () async {
                                              await itemupdater.removeItem(
                                                  cartlist[index].id);
                                            },
                                            icon: Icon(Icons.delete))
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
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
