import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:medicart/Controller/Doctor%20Orders%20Screen%20Controller/doctor_orders_screen_controller.dart';
import 'package:medicart/Utils/color_constants.dart';
import 'package:medicart/View/Admin%20Screens/Order%20Details%20Screen/order_details_screen.dart';
import 'package:medicart/View/Doctor%20Screens/Doctor%20Order%20Details%20Screen/doctor_order_details_screen.dart';

class DoctorOrdersScreen extends ConsumerWidget {
  const DoctorOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final controller =
        ref.read(DoctorOrdersScreenStateNotifierProvider.notifier);

    final doctorOrdersStream =
        controller.getAllDoctorApprovalWaitingOrdersStream();

    return Scaffold(
      appBar: AppBar(title: const Text("Doctor Approval Orders")),
      body: StreamBuilder<QuerySnapshot>(
        stream: doctorOrdersStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            log(snapshot.error.toString());
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data!.docs;

          if (orders.isEmpty) {
            return const Center(child: Text("No orders awaiting approval."));
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final ordereditemid = order.id;
              final data = order.data() as Map<String, dynamic>;

              final productName = data['product_name'] ?? 'Unknown';
              final quantity = data['quantity'] ?? 'N/A';
              final status = data['status'] ?? 'N/A';
              final imgUrl = data['img_url'] ?? '';
              final code = data['code'] ?? '';
              final street_address = data['street_address'] ?? '';
              final pin_code = data['pin_code'] ?? '';
              final amount = data['amount'] ?? '';
              final city = data['city'] ?? '';
              final country = data['country'] ?? '';
            
              final customer_name = data['customer_name'] ?? '';
              final payment_method = data['payment_method'] ?? '';
              final state = data['state'] ?? '';
              final phone_number = data['phone_number'] ?? '';
              final pathSegments = order.reference.path.split('/');
              final userId = pathSegments[
                  1]; // orders_for_doctors/[userId]/ordered_products/[orderId]
              final orderId = order.id;

              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.03,
                  vertical: screenHeight * 0.01,
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DoctorOrderDetailsScreen(
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
                            user_id: userId,
                            imgurl: imgUrl,
                            product_name: productName,
                            no_of_items: quantity,
                          ),
                        ));
                  },
                  child: Container(
                    padding: EdgeInsets.all(screenWidth * 0.03),
                    decoration: BoxDecoration(
                      color: ColorConstants.cartCardwhite,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: screenWidth * 0.2,
                          height: screenHeight * 0.08,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(imgUrl),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[200],
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.04),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                productName,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.05,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "Quantity: $quantity",
                                style: TextStyle(fontSize: screenWidth * 0.04),
                              ),
                              Text(
                                "Status: $status",
                                style: TextStyle(fontSize: screenWidth * 0.04),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.cancel, color: Colors.red),
                          onPressed: () async {
                            await controller.cancelDoctorOrder(
                              userId: userId,
                              orderedItemId: orderId,
                            );
                          },
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
