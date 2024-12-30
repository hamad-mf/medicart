import 'package:flutter/material.dart';
import 'package:medicart/Utils/color_constants.dart';
import 'package:medicart/View/Admin%20Screens/Admin%20Login%20Screen/admin_login_screen.dart';
import 'package:medicart/View/Customer%20Screens/Login%20Screen/login_screen.dart';
import 'package:medicart/View/Doctor%20Screens/Doctor%20Login%20Screen/doctor_login_screen.dart';

class ProfileSelecctionScreen extends StatelessWidget {
  const ProfileSelecctionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.mainbg,
      body: Column(
        children: [
          SizedBox(
            height: 120,
          ),
          Center(
            child: Text(
              "Who are you",
              style: TextStyle(
                  fontSize: 30,
                  color: ColorConstants.mainblack,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ));
                },
                child: Container(
                  width: 120,
                  height: 100,
                  decoration: BoxDecoration(
                      color: ColorConstants.mainwhite,
                      border:
                          Border.all(color: ColorConstants.mainblack, width: 4),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      "Customer",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.mainblack),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 30,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DoctorLoginScreen()));
                },
                child: Container(
                  width: 120,
                  height: 100,
                  decoration: BoxDecoration(
                      color: ColorConstants.mainwhite,
                      border:
                          Border.all(color: ColorConstants.mainblack, width: 4),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      "Doctor",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.mainblack),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AdminLoginScreen()));
            },
            child: Container(
              width: 120,
              height: 100,
              decoration: BoxDecoration(
                  color: ColorConstants.mainwhite,
                  border: Border.all(color: ColorConstants.mainblack, width: 4),
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Text(
                  "Admin",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.mainblack),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
