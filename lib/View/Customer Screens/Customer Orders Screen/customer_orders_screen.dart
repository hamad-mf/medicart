import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicart/Controller/Customer%20Orders%20Screen%20Controller/customer_orders_screen_controller.dart';
import 'package:medicart/Utils/color_constants.dart';

class CustomerOrdersScreen extends ConsumerWidget {
  const CustomerOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final ordersController =
        ref.read(CustomerOrdersScreenStateNotifierProvider.notifier);

    final userOrdersStream = ordersController
        .getUserOrdersStream(FirebaseAuth.instance.currentUser!.uid);

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: userOrdersStream,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("something went wrong"),
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
                      height: screenHeight * 0.4,
                    ),
                    Text(
                      "No items orders",
                      style: TextStyle(fontSize: screenWidth * 0.05),
                    )
                  ],
                ),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final OrdersItem = snapshot.data!.docs[index];
                final OrderedItemId = OrdersItem.id;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                    height: screenHeight * 0.13,
                    decoration: BoxDecoration(
                      color: ColorConstants.cartCardwhite,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                // Navigator.push(...)
                              },
                              child: Container(
                                width: screenWidth * 0.22,
                                height: screenHeight * 0.10,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(OrdersItem['img_url']),
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
                                    OrdersItem['product_name'],
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.05,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  SizedBox(height: screenHeight * 0.001),
                                  Text("No of items:${OrdersItem["quantity"]}"),
                                  SizedBox(height: screenHeight * 0.001),
                                  Text(
                                    "Amount:${OrdersItem["amount"]}",
                                    style: TextStyle(
                                        fontSize: screenWidth * 0.05,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 8,
                          right: 0,
                          child: PopupMenuButton<String>(
                            icon: Icon(Icons.more_vert),
                            onSelected: (value) {
                              if (value == 'details') {
                                log("1");
                              } else if (value == 'cancel') {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Cancel Order?'),
                                      content: Text(
                                          'Are you sure to cancel your order'),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            'No',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            await ordersController.cancelAnItem(
                                                FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                OrderedItemId);
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            'Yes',
                                            style:
                                                TextStyle(color: Colors.green),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            itemBuilder: (BuildContext context) => [
                              PopupMenuItem<String>(
                                value: 'details',
                                child: Text('details'),
                              ),
                              PopupMenuItem<String>(
                                value: 'cancel',
                                child: Text('cancel'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
