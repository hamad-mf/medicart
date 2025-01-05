import 'package:flutter/material.dart';
import 'package:medicart/View/Common%20Screens/Profile%20Selection%20Screen/profile_selecction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    Future<void> _logout() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAdminLoggedIn', false); // Set isLoggedIn to false

      // Navigate back to LoginScreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => ProfileSelecctionScreen()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                _logout();
              },
              icon: Icon(Icons.exit_to_app)),
        ],
      ),
    );
  }
}
