import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicart/Controller/Admin%20Orders%20Screen%20Controller/admin_orders_screen_controller.dart';
import 'package:medicart/Utils/app_utils.dart';
import 'package:medicart/Utils/color_constants.dart';
import 'package:medicart/View/Admin%20Screens/Order%20Details%20Screen/order_details_screen.dart';

class AdminOrdersScreen extends ConsumerWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final allOrdersController =
        ref.watch(AdminOrdersScreenStateNotifierProvider.notifier);

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
              final ordereditemid = allOrdersItem.id;
              final allOrdersItemData =
                  allOrdersItem.data() as Map<String, dynamic>;
              final imgurl = allOrdersItemData['img_url'] ?? '';
              final productName =
                  allOrdersItemData['product_name'] ?? 'No Name';
              final no_of_items = allOrdersItemData['quantity'] ?? 'N/A';
              final code = allOrdersItemData['code'] ?? 'N/A';
              final user_id = allOrdersItemData['userid'] ?? "N/A";
              final customer_name = allOrdersItemData['name'] ?? "N/A";
              final phone_number = allOrdersItemData['phone_number'] ?? "N/A";
              final payment_method =
                  allOrdersItemData["payment_method"] ?? "N/A";
              final pin_code = allOrdersItemData["pin_code"] ?? "N/A";
              final state = allOrdersItemData["state"] ?? "N/A";
              final street_address =
                  allOrdersItemData["street_address"] ?? "N/A";
              final country = allOrdersItemData["country"] ?? "N/A";
              final amount = allOrdersItemData["amount"] ?? "N/A";
              final city = allOrdersItemData["city"] ?? "N/A";
              final status = allOrdersItemData["status"] ?? "N/A";
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                child: InkWell(
                  onTap: () {
                    if (status == 'processing' ||
                        status == 'Doctor Approved' ||
                        status == 'accepted' ||
                        status == "Declined") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderDetailsScreen(
                              ordereditemid: ordereditemid,
                              status: status,
                              amount: amount,
                              city: city,
                              country: country,
                              customer_name: customer_name,
                              payment_method: payment_method,
                              state: state,
                              phone_number: phone_number,
                              pin_code: pin_code,
                              street_address: street_address,
                              code: code,
                              user_id: user_id,
                              imgurl: imgurl,
                              product_name: productName,
                              no_of_items: no_of_items,
                            ),
                          ));
                    } else {
                      AppUtils.showSnackbar(
                          context: context,
                          message: "Wait for doctor to approve",
                          bgcolor: Colors.green);
                    }
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
                              Text(
                                "Status: $status",
                                style: TextStyle(fontSize: screenWidth * 0.04),
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
