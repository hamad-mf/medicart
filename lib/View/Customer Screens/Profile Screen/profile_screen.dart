import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicart/Utils/color_constants.dart';
import 'package:medicart/View/Admin%20Screens/Orders%20Screen/orders_screen.dart';
import 'package:medicart/View/Common%20Screens/Profile%20Selection%20Screen/profile_selecction_screen.dart';
import 'package:medicart/View/Customer%20Screens/Customer%20Orders%20Screen/customer_orders_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false); // Set isLoggedIn to false

    // Navigate back to LoginScreen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => ProfileSelecctionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (uid == null) {
      return Scaffold(
        appBar: AppBar(title: Text("My Profile")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final Stream<DocumentSnapshot<Map<String, dynamic>>> detailsStream =
        FirebaseFirestore.instance
            .collection('profile_details')
            .doc(uid)
            .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text("My Profile"),
        actions: [
          IconButton(
              onPressed: () {
                _logout();
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: detailsStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Something went wrong'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasData && snapshot.data!.data() != null) {
                    final data = snapshot.data!.data()!;
                    final shippingAddress = data['shipping_address'] ?? {};

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 30),
                          Center(
                            child: CircleAvatar(
                              radius: 80,
                              child: Icon(Icons.person, size: 130),
                            ),
                          ),
                          SizedBox(height: 10),
                          Center(
                            child: Text(
                              data['full_name'] ?? "Name",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Personal Details",
                            style: TextStyle(
                                color: ColorConstants.mainblack, fontSize: 18),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                "Full Name: ",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: ColorConstants.mainred),
                              ),
                              Text(
                                data['full_name'] ?? "",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                "Email: ",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: ColorConstants.mainred),
                              ),
                              Text(
                                data['email'] ?? "",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                "Phone Number: ",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: ColorConstants.mainred),
                              ),
                              Text(
                                data['phn']?.toString() ?? "",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Address Details",
                            style: TextStyle(
                                color: ColorConstants.mainblack, fontSize: 18),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                "City: ",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: ColorConstants.mainred),
                              ),
                              Text(
                                shippingAddress['city'] ?? "",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                "Country: ",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: ColorConstants.mainred),
                              ),
                              Text(
                                shippingAddress['country'] ?? "",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                "Pin Code: ",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: ColorConstants.mainred),
                              ),
                              Text(
                                shippingAddress['pin_code'] ?? "",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                "State: ",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: ColorConstants.mainred),
                              ),
                              Text(
                                shippingAddress['state'] ?? "",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                "Street Address: ",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: ColorConstants.mainred),
                              ),
                              Text(
                                shippingAddress['street_address'] ?? "",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }

                  return Center(child: Text('No data available.'));
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                style: ButtonStyle(
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder()),
                    backgroundColor:
                        WidgetStatePropertyAll(ColorConstants.cartCardwhite),
                    minimumSize: WidgetStatePropertyAll(Size(100, 40))),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomerOrdersScreen(),
                      ));
                },
                child: Text("Orders"))
          ],
        ),
      ),
    );
  }
}
