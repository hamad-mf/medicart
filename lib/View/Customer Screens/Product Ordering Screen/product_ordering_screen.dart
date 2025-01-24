import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicart/Utils/color_constants.dart';

// ignore: must_be_immutable
class ProductOrderingScreen extends StatefulWidget {
  String imgUrl;

  ProductOrderingScreen({super.key, required this.imgUrl});

  @override
  State<ProductOrderingScreen> createState() => _ProductOrderingScreenState();
}

class _ProductOrderingScreenState extends State<ProductOrderingScreen> {
  String? uid;

  @override
  void initState() {
    super.initState();
    getCurrentUserUID();
  }

  void getCurrentUserUID() {
    final User? user =
        FirebaseAuth.instance.currentUser; // Get the current user
    if (user != null) {
      setState(() {
        uid = user.uid; // Retrieve the UID
      });
    } else {
      print("No user is currently signed in.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    // Ensure uid is not null before creating the Firestore stream
    if (uid == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Order Summary"),
        ),
        body: Center(
          child: Text("User is not signed in."),
        ),
      );
    }

    final Stream<DocumentSnapshot<Map<String, dynamic>>> detailsStream =
        FirebaseFirestore.instance
            .collection('profile_details')
            .doc(uid)
            .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text("Order Summary"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress Bar Row
          Row(
            children: [
              Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: screenWidth * 0.04)),
              Icon(
                Icons.check_circle,
                size: screenWidth * 0.06,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                child: Container(
                    height: 1.0,
                    width: screenWidth * 0.27,
                    color: Colors.black),
              ),
              Icon(
                Icons.check_circle_outline,
                size: screenWidth * 0.06,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                child: Container(
                    height: 1.0,
                    width: screenWidth * 0.27,
                    color: Colors.black),
              ),
              Icon(
                Icons.check_circle_outline,
                size: screenWidth * 0.06,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04, vertical: screenHeight * 0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Deliver to:",
                      style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    TextButton(onPressed: () {}, child: Text("Change"))
                  ],
                ),
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: detailsStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Something went wrong',
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasData && snapshot.data!.data() != null) {
                      final data = snapshot.data!.data()!;
                      final shippingAddress = data['shipping_address'] ?? {};
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['full_name'],
                            style: TextStyle(
                                fontSize: screenWidth * 0.06,
                                fontWeight: FontWeight.w600),
                          ),
                          Row(
                            children: [
                              Text("${shippingAddress['city']},"),
                              SizedBox(
                                width: screenWidth * 0.02,
                              ),
                              Text(shippingAddress['state']),
                            ],
                          ),
                          Row(
                            children: [
                              Text("${shippingAddress['country']},"),
                              SizedBox(
                                width: screenWidth * 0.02,
                              ),
                              Text(shippingAddress['pin_code']),
                            ],
                          ),
                          Text(shippingAddress['street_address']),
                          Text(
                            data['full_name'],
                          ),
                          Text(
                            data['phn'].toString(),
                          )
                        ],
                      );
                    } else {
                      return Center(
                        child: Text(
                          'No data found',
                          style: TextStyle(fontSize: screenWidth * 0.04),
                        ),
                      );
                    }
                  },
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                Container(
                  width: screenWidth * 0.23,
                  height: screenHeight * 0.14,
                  decoration: BoxDecoration(
                      color: ColorConstants.cartCardwhite,
                      image: DecorationImage(
                          image: NetworkImage(
                            widget.imgUrl,
                          ),
                          fit: BoxFit.cover)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
