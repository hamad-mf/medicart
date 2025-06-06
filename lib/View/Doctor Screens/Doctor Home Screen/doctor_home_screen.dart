import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicart/View/Common%20Screens/Profile%20Selection%20Screen/profile_selecction_screen.dart';
import 'package:medicart/View/Doctor%20Screens/Doctor%20Orders%20Screen/doctor_orders_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorHomeScreen extends ConsumerWidget {
  const DoctorHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> _logout() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDoctorLoggedIn', false); // Set isLoggedIn to false

      // Navigate back to LoginScreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => ProfileSelecctionScreen()),
      );
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DoctorOrdersScreen()));
                },
                child: Text("Dcotor orders")),
            ElevatedButton(
                onPressed: () {
                  _logout();
                },
                child: Text("logout")),
          ],
        ),
      ),
    );
  }
}
