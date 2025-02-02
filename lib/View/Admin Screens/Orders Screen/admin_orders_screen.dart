import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicart/Controller/Admin%20Orders%20Screen%20Controller/admin_orders_screen_controller.dart';
import 'package:medicart/Utils/color_constants.dart';

class AdminOrdersScreen extends ConsumerWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final allOrdersController =
        ref.read(AdminOrdersScreenStateNotifierProvider.notifier);

    final adminAllOrdersStream = allOrdersController.getAllOrderProductsStream();

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Orders"),
      ),
      body: StreamBuilder<List<DocumentSnapshot>>(
        stream: adminAllOrdersStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Something went wrong: ${snapshot.error}"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          // Fixed: Use .isEmpty on the list directly
          if (snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: screenHeight * 0.4,
                  ),
                  Text(
                    "No items ordered",
                    style: TextStyle(fontSize: screenWidth * 0.05),
                  ),
                ],
              ),
            );
          }

          // Fixed: Iterate through the list directly
          for (var doc in snapshot.data!) {
            log(doc.data().toString());
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            // Fixed: Use .length on the list
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              // Fixed: Access via list index
              final allOrdersItem = snapshot.data![index];
              final allOrdersItemData = allOrdersItem.data() as Map<String, dynamic>;

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                  height: screenHeight * 0.13,
                  decoration: BoxDecoration(
                    color: ColorConstants.cartCardwhite,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Container(
                          width: screenWidth * 0.22,
                          height: screenHeight * 0.10,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(allOrdersItemData['img_url'] ?? ''),
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              allOrdersItemData['product_name'] ?? 'No Name',
                              style: TextStyle(
                                fontSize: screenWidth * 0.05,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              "No of items: ${allOrdersItemData['quantity'] ?? 'N/A'}",
                              style: TextStyle(fontSize: screenWidth * 0.04),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              "Amount: ${allOrdersItemData['amount'] ?? 'N/A'}",
                              style: TextStyle(
                                fontSize: screenWidth * 0.05,
                                fontWeight: FontWeight.bold,
                              ),
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
    );
  }
}