import 'dart:async';

import 'package:flutter/material.dart';
import 'package:medicart/Utils/color_constants.dart';
import 'package:medicart/Utils/image_constants.dart';
import 'package:medicart/View/Login%20Screen/login_screen.dart';
import 'package:medicart/View/Registration%20Screen/registration_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => RegistrationScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.mainwhite,
      body: Center(
        child: Image.asset(ImageConstants.Splashlogo),
      ),
    );
  }
}
