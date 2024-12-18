import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:medicart/Utils/color_constants.dart';
import 'package:medicart/Utils/image_constants.dart';
import 'package:medicart/View/Customer%20Screens/Custom%20BottomNavBar/custom_bottom_navbar.dart';
import 'package:medicart/View/Customer%20Screens/Home%20Screen/home_screen.dart';
import 'package:medicart/View/Customer%20Screens/Login%20Screen/login_screen.dart';


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
    _checkLoginStatus();  // Call method to check login status
  }

  // Method to check login status
  void _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;  // Get 'isLoggedIn' flag

    // Wait for 4 seconds, then navigate based on login status
    Timer(Duration(seconds: 4), () {
      if (isLoggedIn) {
        // Navigate to HomeScreen if logged in
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => CustomBottomNavbar()));
      } else {
        // Navigate to LoginScreen if not logged in
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
      }
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
