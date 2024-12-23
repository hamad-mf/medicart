import 'package:flutter/material.dart';
import 'package:medicart/View/Common%20Screens/Profile%20Selection%20Screen/profile_selection_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorHomeScreen extends StatelessWidget {
  const DoctorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> _doctorlogout() async {
      SharedPreferences adminprefs = await SharedPreferences.getInstance();
      await adminprefs.setBool(
          'isDoctorLoggedIn', false); // Set isDoctorLoggedIn to false

      // Navigate back to LoginScreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => ProfileSelectionScreen()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                _doctorlogout();
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
    );
  }
}
