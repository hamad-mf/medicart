import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicart/Controller/Admin%20Orders%20Screen%20Controller/admin_orders_screen_controller.dart';
import 'package:medicart/Utils/color_constants.dart';

// ignore: must_be_immutable
class OrderDetailsScreen extends ConsumerWidget {
  String imgurl;
  String product_name;
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.03),
        child: Column(
          children: [
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
                      fontWeight: FontWeight.bold),
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
                      fontWeight: FontWeight.bold),
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
                      fontWeight: FontWeight.bold),
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
                    if (snapshot.connectionState == ConnectionState.waiting) {
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
                              image:
                                  NetworkImage(snapshot.data!), // Correct URL
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
                      fontWeight: FontWeight.bold),
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
                      fontWeight: FontWeight.bold),
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
                      fontWeight: FontWeight.bold),
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
                      fontWeight: FontWeight.bold),
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
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
