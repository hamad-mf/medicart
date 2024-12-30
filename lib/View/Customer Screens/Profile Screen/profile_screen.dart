import 'package:flutter/material.dart';
import 'package:medicart/View/Common%20Screens/Profile%20Selection%20Screen/profile_selecction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    Future<void> _logout() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false); // Set isLoggedIn to false

      // Navigate back to LoginScreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => ProfileSelecctionScreen()),
      );
    }

    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              _logout();
            },
            child: Text("logout")),
      ),
    );
  }
}
