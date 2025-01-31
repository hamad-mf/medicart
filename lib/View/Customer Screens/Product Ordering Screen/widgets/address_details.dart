import 'package:flutter/material.dart';

class AddressDetails extends StatelessWidget {
  final String name;
  final String phone;
  final String city;
  final String state;
  final String country;
  final String pinCode;
  final String streetAddress;
  final double screenWidth;

  const AddressDetails({
    super.key,
    required this.name,
    required this.phone,
    required this.city,
    required this.state,
    required this.country,
    required this.pinCode,
    required this.streetAddress,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: TextStyle(fontSize: screenWidth * 0.06, fontWeight: FontWeight.w600)),
        Row(
          children: [
            Text("$city,"),
            SizedBox(width: screenWidth * 0.02),
            Text(state),
          ],
        ),
        Row(
          children: [
            Text("$country,"),
            SizedBox(width: screenWidth * 0.02),
            Text(pinCode),
          ],
        ),
        Text(streetAddress),
        Text(phone),
      ],
    );
  }
}