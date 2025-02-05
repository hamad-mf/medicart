import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicart/Controller/Admin%20Orders%20Screen%20Controller/admin_orders_screen_controller.dart';
import 'package:medicart/Utils/color_constants.dart';
import 'package:medicart/View/Admin%20Screens/Order%20Details%20Screen/order_details_screen.dart';

class AdminOrdersScreen extends ConsumerWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final allOrdersController =
        ref.read(AdminOrdersScreenStateNotifierProvider.notifier);

    final adminAllOrdersStream =
        allOrdersController.getAllOrderProductsStream();

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

          if (snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "No Orders",
                    style: TextStyle(fontSize: screenWidth * 0.05),
                  ),
                ],
              ),
            );
          }

          //for debugging
          // for (var doc in snapshot.data!) {
          //   log(doc.data().toString());
          // }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            // Fixed: Use .length on the list
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              // Fixed: Access via list index
              final allOrdersItem = snapshot.data![index];
              final allOrdersItemData =
                  allOrdersItem.data() as Map<String, dynamic>;
              final imgurl = allOrdersItemData['img_url'] ?? '';
              final productName =
                  allOrdersItemData['product_name'] ?? 'No Name';
              final no_of_items = allOrdersItemData['quantity'] ?? 'N/A';
              final code = allOrdersItemData['code'] ?? 'N/A';
              final user_id = allOrdersItemData['userid'] ?? "N/A";
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetailsScreen(
                            code: code,
                            user_id: user_id,
                            imgurl: imgurl,
                            product_name: productName,
                            no_of_items: no_of_items,
                          ),
                        ));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                    height: screenHeight * 0.11,
                    decoration: BoxDecoration(
                      color: ColorConstants.cartCardwhite,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Container(
                            width: screenWidth * 0.20,
                            height: screenHeight * 0.08,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(imgurl),
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
                                productName,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.05,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "No of items: ${no_of_items}",
                                    style:
                                        TextStyle(fontSize: screenWidth * 0.04),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
