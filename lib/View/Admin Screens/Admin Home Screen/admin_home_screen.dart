import 'package:flutter/material.dart';
import 'package:medicart/Utils/color_constants.dart';
import 'package:medicart/View/Admin%20Screens/Settings%20Screen/settings_screen.dart';
import 'package:medicart/View/Admin%20Screens/Orders%20Screen/orders_screen.dart';
import 'package:medicart/View/Admin%20Screens/Admins%20Screen/admins_screen.dart';
import 'package:medicart/View/Admin%20Screens/Product%20Adding%20Screen/product_adding_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    List Screens = [
      ProductAddingScreen(),
      OrdersScreen(),
      AdminsScreen(),
      SettingsScreen()
    ];
    List optionsText = ["Add a Product", "Orders", "Admins", "Settings"];
    return Scaffold(
      backgroundColor: ColorConstants.mainbg,
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06, vertical: screenHeight * 0.03),
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.1,
            ),
            Text(
              "Select An Option",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Screens[index]));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.06),
                        height: screenHeight * 0.1,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                width: screenWidth * 0.01,
                                color: Colors.black)),
                        child: Row(
                          children: [
                            Text(
                              optionsText[index],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * 0.045),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: screenHeight * 0.03,
                    );
                  },
                  itemCount: 4),
            ),
          ],
        ),
      ),
    );
  }
}
