

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicart/Controller/Add%20To%20Cart%20Controller/add_to_cart_controller.dart';
import 'package:medicart/Controller/Add%20To%20Cart%20Controller/add_to_cart_state.dart';
import 'package:medicart/Utils/color_constants.dart';
import 'package:medicart/View/Customer%20Screens/Product%20Ordering%20Screen/product_ordering_screen.dart';
import 'package:medicart/View/Customer%20Screens/Upload%20Prescription%20Screen/upload_prescription_screen.dart';
import 'package:medicart/View/Global%20Widgets/custom_button.dart';

// ignore: must_be_immutable
class ProductScreen extends ConsumerWidget {
  String product_name;
  String image_url;
  String category;
  bool isPresNeeded;
  String details;
  num price;
  num stocks;
  String usage;

  ProductScreen(
      {super.key,
      required this.isPresNeeded,
      required this.product_name,
      required this.image_url,
      required this.category,
      required this.details,
      required this.price,
      required this.stocks,
      required this.usage});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final addtocartstate =
        ref.watch(AddToCartScreenStateNotifierProvider) as AddToCartState;
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios_new)),
        actions: [
          Icon(Icons.favorite_border_outlined),
          SizedBox(width: screenHeight * 0.02),
          Icon(Icons.ios_share),
          SizedBox(width: screenWidth * 0.02)
        ],
      ),
      body: Stack(
        children: [
          // Main content of the screen
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  Container(
                    width: double.infinity,
                    height: screenHeight * 0.40,
                    decoration:
                        BoxDecoration(color: Colors.grey.withOpacity(0.3)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          image_url,
                          width: screenWidth * 0.8,
                          height: screenHeight * 0.35,
                          fit: BoxFit.contain,
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  // Product Details
                  Text(
                    product_name,
                    style: TextStyle(
                        color: ColorConstants.mainblack,
                        fontSize: screenWidth * 0.07,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    details,
                    style: TextStyle(
                        color: ColorConstants.mainblack.withOpacity(0.7),
                        fontSize: screenWidth * 0.04),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Row(
                    children: [
                      Text(
                        "₹${price.toString()}",
                        style: TextStyle(
                            color: ColorConstants.mainblack,
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.06),
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      Text("${stocks.toString()} left")
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  // Prescription Indicator
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    width: screenWidth * 0.35,
                    height: screenHeight * 0.03,
                    decoration: BoxDecoration(
                        color: isPresNeeded
                            ? ColorConstants.mainred.withOpacity(0.6)
                            : ColorConstants.appbar.withOpacity(0.8)),
                    child: Row(
                      children: [
                        Text(
                          "Prescription: ${isPresNeeded ? ' Yes' : ' No'}",
                          style: TextStyle(
                              fontSize: screenWidth * 0.035,
                              color: ColorConstants.mainwhite,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  RichText(
                    text: TextSpan(
                      text: 'Usage: ',
                      style: TextStyle(
                          color: ColorConstants.mainblack,
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.04),
                      children: [
                        TextSpan(
                            text: usage,
                            style: TextStyle(
                                color: ColorConstants.mainblack,
                                fontWeight: FontWeight.normal,
                                fontSize: 15))
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.10),
                  // Buttons Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: customButton(
                          onPressed: () async {
                            if (isPresNeeded) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Prescription Required'),
                                    content: Text(
                                        'This product requires a prescription. Please upload it to proceed.'),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                           Navigator.pop(context);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    UploadPrescriptionScreen(
                                                        category: category,
                                                        context: context,
                                                        details: details,
                                                        image_url: image_url,
                                                        itemcount: 1,
                                                        price: price,
                                                        total_price: price,
                                                        requiresPrescription:
                                                            isPresNeeded,
                                                        stocks: stocks,
                                                        user_id: FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid,
                                                        usage: usage,
                                                        ProductName:
                                                            product_name),
                                              ));
                                        },
                                        child: Text(
                                          'Upload Prescription',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              ref
                                  .read(AddToCartScreenStateNotifierProvider
                                      .notifier)
                                  .onAddToCart(
                                      userId: FirebaseAuth
                                          .instance.currentUser!.uid,
                                      total_price: price,
                                      category: category,
                                      details: details,
                                      image_url: image_url,
                                      product_name: product_name,
                                      usage: usage,
                                      price: price,
                                      stocks: stocks,
                                      requiresPrescription: isPresNeeded,
                                      itemcount: 1,
                                      context: context);
                            }
                          },
                          text: "Add to cart",
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      Expanded(
                        child: customButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductOrderingScreen(
                                    imgUrl: image_url,
                                    price: price,
                                    proName: product_name,
                                  ),
                                ));
                          },
                          text: "Buy now",
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.03),
                ],
              ),
            ),
          ),

          if (addtocartstate.isloading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(
                    color: ColorConstants.mainwhite,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
