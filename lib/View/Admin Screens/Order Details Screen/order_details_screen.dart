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
  String user_id;
  OrderDetailsScreen(
      {super.key,
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
                  style: TextStyle(fontSize: screenWidth * 0.05),
                ),
                Text(
                  product_name,
                  style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            Row(
              children: [
                Text(
                  "No of items: ",
                  style: TextStyle(fontSize: screenWidth * 0.05),
                ),
                Text(
                  no_of_items,
                  style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            Row(
              children: [
                Text(
                  "product image: ",
                  style: TextStyle(fontSize: screenWidth * 0.05),
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
            SizedBox(
              height: screenHeight * 0.02,
            ),
            Row(
              children: [
                Text(
                  "code: ",
                  style: TextStyle(fontSize: screenWidth * 0.05),
                ),
                Text(
                  code,
                  style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            Row(
              children: [
                Text(
                  "prescription: ",
                  style: TextStyle(fontSize: screenWidth * 0.05),
                ),
                FutureBuilder<String?>(
                  future: preUrl, // Wait for the URL to load
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(); // Show a loader while fetching
                    } else if (snapshot.hasError) {
                      return const Text("Error loading prescription.");
                    } else if (snapshot.hasData && snapshot.data != null) {
                      return Container(
                        width: screenWidth * 0.4,
                        height: screenHeight * 0.2,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(snapshot.data!), // Correct URL
                            fit: BoxFit.cover,
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
          ],
        ),
      ),
    );
  }
}
