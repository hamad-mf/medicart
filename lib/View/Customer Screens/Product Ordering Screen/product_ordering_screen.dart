import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProductOrderingScreen extends StatefulWidget {
  const ProductOrderingScreen({super.key});

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
              Padding(padding: EdgeInsets.symmetric(horizontal: 16)),
              Icon(
                Icons.check_circle,
                size: 23,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child:
                    Container(height: 1.0, width: 110.0, color: Colors.black),
              ),
              Icon(
                Icons.check_circle_outline,
                size: 23,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child:
                    Container(height: 1.0, width: 110.0, color: Colors.black),
              ),
              Icon(
                Icons.check_circle_outline,
                size: 23,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Deliver to:",
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    TextButton(onPressed: () {}, child: Text("Change"))
                  ],
                ),
                // StreamBuilder for Firestore data
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
                            data['full_name'] ?? "Name",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w600),
                          ),
                          Text(shippingAddress['city'])
                        ],
                      );
                    } else {
                      return Center(
                        child: Text(
                          'No data found',
                          style: TextStyle(fontSize: 16),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
