import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medicart/View/Common%20Screens/Profile%20Selection%20Screen/profile_selection_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String docId;
  Stream<QuerySnapshot>? _profileDetailsStream;
  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false); // Set isLoggedIn to false

    // Navigate back to LoginScreen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => ProfileSelectionScreen()),
    );
  }

  Future<void> _initializeStream() async {
    // Retrieve the docId from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    docId = prefs.getString('docId') ?? '';
    print('Retrieved docId: $docId'); // Debug: Print docId

    if (docId.isNotEmpty) {
      // Initialize the stream with the retrieved docId
      setState(() {
        _profileDetailsStream = FirebaseFirestore.instance
            .collection('customers')
            .doc(docId) // Use the retrieved document ID
            .collection('DeliveryDetails') // Subcollection name
            .snapshots();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Profile Details')),
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              _profileDetailsStream == null
                  ? const Center(child: CircularProgressIndicator())
                  : StreamBuilder<QuerySnapshot>(
                      stream: _profileDetailsStream,
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Center(
                              child: Text('Something went wrong'));
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                              child: Text('No delivery details found.'));
                        }

                        Map<String, dynamic> data = snapshot.data!.docs.first
                            .data()! as Map<String, dynamic>;
                        String name = data['name'] ?? 'no name';
                        String CityTown = data['City/Town'] ?? 'no data';
                        String DeliveryInstructions =
                            data['Delivery Instructions'] ?? 'no data';
                        String HouseNumber =
                            data['House/Flat Number'] ?? 'no data';
                        String Landmark = data['Landmark'] ?? 'no data';
                        String Pincode = data['Pincode'] ?? 'no data';
                        String StreetName =
                            data['Street Name/Locality'] ?? 'no data';
                        String mobilenumber =
                            data['mobile number'] ?? 'no data';

                        return Column(children: [
                          Text(name),
                          Text(CityTown),
                          Text(DeliveryInstructions),
                          Text(HouseNumber),
                          Text(Landmark),
                          Text(Pincode),
                          Text(StreetName),
                          Text(mobilenumber),
                        ]);
                      },
                    ),
              ElevatedButton(
                  onPressed: () {
                    _logout();
                  },
                  child: Text("logout"))
            ],
          ),
        ));
  }
}
