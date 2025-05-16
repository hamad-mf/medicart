
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
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final ordersController = ref.read(CustomerOrdersScreenStateNotifierProvider.notifier);

    final regularOrdersStream = ordersController.getUserOrdersStream(userId);
    final doctorApprovalStream = ordersController.getUserOrdersDoctorApprovelWaitingStream(userId);

    return Scaffold(
      appBar: AppBar(title: const Text("Your Orders")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Regular Orders Section
            StreamBuilder<QuerySnapshot>(
              stream: regularOrdersStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text("Something went wrong"));
                }
                return OrderSection(
                  title: "Regular Orders",
                  snapshot: snapshot,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  ref: ref,
                  onCancel: (orderedItemId) async {
                    await ordersController.cancelAnItem(userId, orderedItemId);
                  },
                );
              },
            ),
            const Divider(thickness: 2),

            // Doctor Approval Orders Section
            StreamBuilder<QuerySnapshot>(
              stream: doctorApprovalStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text("Something went wrong"));
                }
                return OrderSection(
                  title: "Waiting for Doctor Approval",
                  snapshot: snapshot,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  ref: ref,
                  onCancel: (orderedItemId) async {
                    await ordersController.cancelAnItemDoctorApproval(userId, orderedItemId);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class OrderSection extends StatelessWidget {
  final String title;
  final AsyncSnapshot<QuerySnapshot> snapshot;
  final double screenWidth;
  final double screenHeight;
  final WidgetRef ref;
  final Function(String orderedItemId) onCancel;

  const OrderSection({
    super.key,
    required this.title,
    required this.snapshot,
    required this.screenWidth,
    required this.screenHeight,
    required this.ref,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.05),
        child: Center(child: Text("No $title", style: TextStyle(fontSize: screenWidth * 0.05))),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Text(title, style: TextStyle(fontSize: screenWidth * 0.06, fontWeight: FontWeight.bold)),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final OrdersItem = snapshot.data!.docs[index];
            final OrderedItemId = OrdersItem.id;

            return ExpansionTile(
              showTrailingIcon: false,
              title: Container(
                margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                height: screenHeight * 0.13,
                decoration: BoxDecoration(
                  color: ColorConstants.cartCardwhite,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    Row(
                      children: [
                        Container(
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
                              Text("No of items: ${OrdersItem["quantity"]}"),
                              Text(
                                "Amount: ₹${OrdersItem["amount"]}",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.bold,
                                ),
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
                        icon: const Icon(Icons.more_vert),
                        onSelected: (value) {
                          if (value == 'cancel') {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Cancel Order?'),
                                  content: const Text('Are you sure to cancel your order?'),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: const Text('No', style: TextStyle(color: Colors.red)),
                                    ),
                                    TextButton(
                                      onPressed: ref
                                              .watch(CustomerOrdersScreenStateNotifierProvider)
                                              .isloading
                                          ? null
                                          : () async {
                                              await onCancel(OrderedItemId);
                                              Navigator.of(context).pop();
                                            },
                                      child: ref
                                              .watch(CustomerOrdersScreenStateNotifierProvider)
                                              .isloading
                                          ? const CircularProgressIndicator()
                                          : const Text('Yes', style: TextStyle(color: Colors.green)),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          const PopupMenuItem<String>(value: 'cancel', child: Text('Cancel')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Order Status: ${OrdersItem["status"]}",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
