import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicart/Controller/Admin%20Orders%20Screen%20Controller/admin_orders_screen_controller.dart';
import 'package:medicart/Utils/color_constants.dart';
import 'package:medicart/View/Global%20Widgets/custom_button.dart';

// ignore: must_be_immutable
class OrderDetailsScreen extends ConsumerWidget {
  String imgurl;
  String product_name;
  String status;
  String no_of_items;
  String code;
  String customer_name;
  String phone_number;
  String payment_method;
  String pin_code;
  String state;
  String street_address;
  String country;
  int amount;
  String city;
  String user_id;
  OrderDetailsScreen(
      {super.key,
      required this.status,
      required this.amount,
      required this.city,
      required this.country,
      required this.customer_name,
      required this.payment_method,
      required this.state,
      required this.phone_number,
      required this.pin_code,
      required this.street_address,
      required this.user_id,
      required this.code,
      required this.imgurl,
      required this.no_of_items,
      required this.product_name});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allOrdersController =
        ref.read(AdminOrdersScreenStateNotifierProvider.notifier);

    Future<String?> preUrl =
        allOrdersController.getPrescriptionUrlByCode(code, user_id);
    Future<String?> OrderStatus =
        allOrdersController.updateTheStatus(phone_number, user_id);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.03),
        child: Stack(children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Order Details: ",
                  style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: screenHeight * 0.03,
                ),
                Row(
                  children: [
                    Text(
                      "Name of product: ",
                      style: TextStyle(fontSize: screenWidth * 0.04),
                    ),
                    Text(
                      product_name,
                      style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                Row(
                  children: [
                    Text(
                      "No of items: ",
                      style: TextStyle(fontSize: screenWidth * 0.04),
                    ),
                    SizedBox(
                      width: screenWidth * 0.095,
                    ),
                    Text(
                      no_of_items,
                      style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "product image: ",
                      style: TextStyle(fontSize: screenWidth * 0.04),
                    ),
                    SizedBox(
                      width: screenWidth * 0.05,
                    ),
                    Container(
                      width: screenWidth * 0.4,
                      height: screenHeight * 0.2,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                imgurl,
                              ),
                              fit: BoxFit.cover)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "code: ",
                      style: TextStyle(fontSize: screenWidth * 0.04),
                    ),
                    SizedBox(
                      width: screenWidth * 0.22,
                    ),
                    Text(
                      code,
                      style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.04,
                ),
                Row(
                  children: [
                    Text(
                      "prescription: ",
                      style: TextStyle(fontSize: screenWidth * 0.04),
                    ),
                    SizedBox(
                      width: screenWidth * 0.09,
                    ),
                    FutureBuilder<String?>(
                      future: preUrl, // Wait for the URL to load
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator(); // Show a loader while fetching
                        } else if (snapshot.hasError) {
                          return const Text("Error loading prescription.");
                        } else if (snapshot.hasData && snapshot.data != null) {
                          return InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Stack(children: [
                                      Container(
                                        width: double
                                            .infinity, // Set your desired width
                                        height: screenHeight *
                                            0.45, // Set your desired height
                                        padding: EdgeInsets.all(0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            FutureBuilder<String?>(
                                              future:
                                                  preUrl, // Wait for the URL to load
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const CircularProgressIndicator(); // Show a loader while fetching
                                                } else if (snapshot.hasError) {
                                                  return const Text(
                                                      "Error loading prescription.");
                                                } else if (snapshot.hasData &&
                                                    snapshot.data != null) {
                                                  return Container(
                                                    width: double.infinity,
                                                    height: screenHeight * 0.45,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: NetworkImage(snapshot
                                                            .data!), // Correct URL
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  return const Text(
                                                      "No prescription available.");
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: Icon(
                                              Icons.close,
                                              color: ColorConstants.mainwhite,
                                            )),
                                      )
                                    ]),
                                  );
                                },
                              );
                            },
                            child: Container(
                              width: screenWidth * 0.4,
                              height: screenHeight * 0.2,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                      snapshot.data!), // Correct URL
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        } else {
                          return const Text("No prescription available.");
                        }
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Customer name: ",
                      style: TextStyle(fontSize: screenWidth * 0.04),
                    ),
                    SizedBox(
                      width: screenWidth * 0.02,
                    ),
                    Text(
                      customer_name,
                      style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Phone number: ",
                      style: TextStyle(fontSize: screenWidth * 0.04),
                    ),
                    SizedBox(
                      width: screenWidth * 0.04,
                    ),
                    Text(
                      phone_number,
                      style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Total amount: ",
                      style: TextStyle(fontSize: screenWidth * 0.04),
                    ),
                    SizedBox(
                      width: screenWidth * 0.062,
                    ),
                    Text(
                      "₹${amount.toString()}",
                      style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Payment mode: ",
                      style: TextStyle(fontSize: screenWidth * 0.04),
                    ),
                    SizedBox(
                      width: screenWidth * 0.036,
                    ),
                    Text(
                      payment_method,
                      style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                SizedBox(),
                Row(
                  children: [
                    Text(
                      "Total amount: ",
                      style: TextStyle(fontSize: screenWidth * 0.04),
                    ),
                    SizedBox(
                      width: screenWidth * 0.062,
                    ),
                    Text(
                      "₹${amount.toString()}",
                      style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.03,
                ),
                Text(
                  "Delivery Address Details: ",
                  style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: screenHeight * 0.03,
                ),
                Row(
                  children: [
                    Text(
                      "Country: ",
                      style: TextStyle(fontSize: screenWidth * 0.04),
                    ),
                    SizedBox(
                      width: screenWidth * 0.17,
                    ),
                    Text(
                      country,
                      style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "State: ",
                      style: TextStyle(fontSize: screenWidth * 0.04),
                    ),
                    SizedBox(
                      width: screenWidth * 0.22,
                    ),
                    Text(
                      state,
                      style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "City: ",
                      style: TextStyle(fontSize: screenWidth * 0.04),
                    ),
                    SizedBox(
                      width: screenWidth * 0.25,
                    ),
                    Text(
                      city,
                      style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "pin code: ",
                      style: TextStyle(fontSize: screenWidth * 0.04),
                    ),
                    SizedBox(
                      width: screenWidth * 0.16,
                    ),
                    Text(
                      pin_code,
                      style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Street Address: ",
                      style: TextStyle(fontSize: screenWidth * 0.04),
                    ),
                    SizedBox(
                      width: screenWidth * 0.05,
                    ),
                    Text(
                      street_address,
                      style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.03,
                ),
                Row(
                  children: [
                    Text(
                      "Order Status: ",
                      style: TextStyle(fontSize: screenWidth * 0.04),
                    ),
                    SizedBox(
                      width: screenWidth * 0.09,
                    ),
                    StreamBuilder<DocumentSnapshot>(
                      stream: allOrdersController.getstatus(user_id),
                      builder: (context,
                          AsyncSnapshot<DocumentSnapshot> docSnapshot) {
                        if (docSnapshot.hasData) {
                          final OrderDoc = docSnapshot.data!;

                          final status = OrderDoc['status'];

                          return Text(
                            '$status',
                            style: TextStyle(
                                fontSize: screenWidth * 0.05,
                                fontWeight: FontWeight.w400),
                          );
                        }
                        return CircularProgressIndicator();
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.04,
                ),
                Row(
                  children: [
                    customButton(
                        onPressed: () async {
                          await allOrdersController.changeOrderStatus(
                              upddatedStatus: "accepted", userid: user_id);
                        },
                        text: "Accept"),
                    SizedBox(
                      width: screenWidth * 0.048,
                    ),
                    customButton(
                        onPressed: () async {
                          await allOrdersController.changeOrderStatus(
                              upddatedStatus: "Declined", userid: user_id);
                        },
                        text: "Decline"),
                  ],
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
