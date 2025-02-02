import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicart/Controller/Product%20Ordering%20Screen%20Controller/product_ordering_screen_controller.dart';
import 'package:medicart/View/Customer%20Screens/Payment%20Screen/payment_screen.dart';
import 'package:medicart/View/Customer%20Screens/Product%20Ordering%20Screen/widgets/address_details.dart';
import 'package:medicart/View/Customer%20Screens/Product%20Ordering%20Screen/widgets/progress_bar.dart';

import 'package:medicart/Utils/color_constants.dart';

class ProductOrderingScreen extends ConsumerWidget {
  final String imgUrl;
  final num price;
  final String proName;

  const ProductOrderingScreen(
      {super.key,
      required this.imgUrl,
      required this.proName,
      required this.price});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final uid = ref.watch(userUIDProvider);
    final dropdownValue = ref.watch(dropdownValueProvider);

    // Calculate total amount based on quantity
    final totalAmount = price * (int.tryParse(dropdownValue ?? '1') ?? 1);

    if (uid == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Order Summary")),
        body: const Center(child: Text("User is not signed in.")),
      );
    }

    final profileDetailsStream = ref.watch(profileDetailsProvider(uid));

    return Scaffold(
      appBar: AppBar(title: const Text("Order Summary")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress Bar
          ProgressBar(screenWidth: screenWidth),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.03),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Rest of your UI code...
                    // Deliver To Section
                    Row(
                      children: [
                        Text(
                          "Deliver to:",
                          style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        TextButton(
                            onPressed: () {}, child: const Text("Change"))
                      ],
                    ),

                    // StreamBuilder for Profile Details
                    profileDetailsStream.when(
                      data: (snapshot) {
                        if (snapshot == null || !snapshot.exists) {
                          return const Text('No data found');
                        }
                        final data = snapshot.data()!;
                        final shippingAddress = data['shipping_address'] ?? {};

                        // Store address details for payment screen
                        final name = data['full_name'] ?? '';
                        final phone = data['phn']?.toString() ?? '';
                        final city = shippingAddress['city'] ?? '';
                        final state = shippingAddress['state'] ?? '';
                        final country = shippingAddress['country'] ?? '';
                        final pinCode = shippingAddress['pin_code'] ?? '';
                        final streetAddress =
                            shippingAddress['street_address'] ?? '';

                        return Column(
                          children: [
                            AddressDetails(
                              name: name,
                              phone: phone,
                              city: city,
                              state: state,
                              country: country,
                              pinCode: pinCode,
                              streetAddress: streetAddress,
                              screenWidth: screenWidth,
                            ),

                            // Rest of your UI code...
// Product Image
                            SizedBox(height: screenHeight * 0.02),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: screenWidth * 0.23,
                                  height: screenHeight * 0.14,
                                  decoration: BoxDecoration(
                                    color: ColorConstants.cartCardwhite,
                                    image: DecorationImage(
                                      image: NetworkImage(imgUrl),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: screenWidth * 0.02,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      proName,
                                      style: TextStyle(
                                          fontSize: screenWidth * 0.05,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: screenHeight * 0.02,
                                    ),
                                    Text(
                                      "${price.toString()}₹",
                                      style: TextStyle(
                                          fontSize: screenWidth * 0.05,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Row(
                              children: [
                                Text(
                                  "Quantity: ",
                                  style: TextStyle(
                                      fontSize: screenWidth * 0.04,
                                      fontWeight: FontWeight.w500),
                                ),
                                DropdownButton<String>(
                                  value: dropdownValue,
                                  items: qnt.map((nums) {
                                    return DropdownMenuItem<String>(
                                      value: nums,
                                      child: Text(nums),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    ref
                                        .read(dropdownValueProvider.notifier)
                                        .state = value;
                                  },
                                  hint: const Text("1"),
                                ),
                              ],
                            ),

                            // Bottom payment button
                            SizedBox(height: screenHeight * 0.25),
                            Container(
                              padding: EdgeInsets.all(screenWidth * 0.04),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(0, -2),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Total Amount:",
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.045,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "₹${totalAmount.toStringAsFixed(2)}",
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.045,
                                          fontWeight: FontWeight.bold,
                                          color: ColorConstants.mainblack,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: screenHeight * 0.02),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PaymentScreen(
                                              quantity: dropdownValue ?? '1',
                                              img_url: imgUrl,
                                              state: state,
                                              country: country,
                                              pin_code: pinCode,
                                              street_address: streetAddress,
                                              city: city,
                                              phn: phone,
                                              name: name,
                                              amount: totalAmount,
                                              product_name: proName,
                                            ),
                                          ),
                                        );
                                      },
                                      style: ButtonStyle(
                                        textStyle: WidgetStatePropertyAll(
                                          TextStyle(
                                            color: ColorConstants.mainwhite,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                          ),
                                        ),
                                        minimumSize:
                                            const WidgetStatePropertyAll(
                                          Size(175, 50),
                                        ),
                                        shape: WidgetStatePropertyAll(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        foregroundColor: WidgetStatePropertyAll(
                                          Colors.white,
                                        ),
                                        backgroundColor: WidgetStatePropertyAll(
                                          ColorConstants.appbar,
                                        ),
                                      ),
                                      child: Text(
                                        "Continue",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: screenWidth * 0.045,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      error: (error, stackTrace) => Center(
                        child: Text(
                          'Error: $error',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
