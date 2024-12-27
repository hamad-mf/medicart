import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medicart/Utils/color_constants.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
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
                                children: [
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    cartlist[index]["product_name"],
                                    style: TextStyle(fontSize: 19),
                                  ),
                                ],
                              )
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
    );
  }
}
