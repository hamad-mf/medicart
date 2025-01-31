import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double screenWidth;

  const ProgressBar({super.key, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04)),
        Icon(Icons.check_circle, size: screenWidth * 0.06),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
          child: Container(
              height: 1.0, width: screenWidth * 0.27, color: Colors.black),
        ),
        Icon(Icons.check_circle_outline, size: screenWidth * 0.06),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
          child: Container(
              height: 1.0, width: screenWidth * 0.27, color: Colors.black),
        ),
        Icon(Icons.check_circle_outline, size: screenWidth * 0.06),
      ],
    );
  }
}