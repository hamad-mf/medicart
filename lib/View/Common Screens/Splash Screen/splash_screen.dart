import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:medicart/Utils/color_constants.dart';
import 'package:medicart/Utils/image_constants.dart';

import 'package:medicart/View/Common%20Screens/Profile%20Selection%20Screen/profile_selecction_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Call method to check login status
  }

  // Method to check user login status
 void _checkLoginStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Check both user and admin login statuses
  bool isUserLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  bool isAdminLoggedIn = prefs.getBool('isAdminLoggedIn') ?? false;
  bool isDoctorLoggedIn = prefs.getBool('isDoctorLoggedIn') ?? false;

  // Wait for 4 seconds, then navigate based on login status
  Timer(Duration(seconds: 4), () {
    // if (isAdminLoggedIn) {
    //   // Navigate to Admin HomeScreen
    //   Navigator.of(context).pushReplacement(
    //       MaterialPageRoute(builder: (_) => ProductAddingScreen()));
    // } else if (isUserLoggedIn) {
    //   // Navigate to User HomeScreen
    //   Navigator.of(context).pushReplacement(
    //       MaterialPageRoute(builder: (_) => CustomBottomNavbarScreen()));
    // } else if (isDoctorLoggedIn) {
    //   // Navigate to User HomeScreen
    //   Navigator.of(context).pushReplacement(
    //       MaterialPageRoute(builder: (_) => DoctorHomeScreen()));
    // } else {
    //   // Navigate to Profile Selection Screen
    //   Navigator.of(context).pushReplacement(
    //       MaterialPageRoute(builder: (_) => ProfileSelecctionScreen()));
    // }

    Navigator.of(context).pushReplacement(
           MaterialPageRoute(builder: (_) => ProfileSelecctionScreen()));
  });
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.mainbg,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 200),
            Image.asset(
              ImageConstants.Splashlogo,
              scale: 1.2,
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 20),
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'MEDICART',
                      textStyle: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      speed: Duration(milliseconds: 100),
                    ),
                  ],
                  isRepeatingAnimation: true,
                  totalRepeatCount: 100,
                  pause: Duration(milliseconds: 500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
