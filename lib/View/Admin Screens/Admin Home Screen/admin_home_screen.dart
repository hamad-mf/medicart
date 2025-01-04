import 'package:flutter/material.dart';
import 'package:medicart/Utils/color_constants.dart';
import 'package:medicart/View/Admin%20Screens/Dummy%20Screen1/dummy_screen1.dart';
import 'package:medicart/View/Admin%20Screens/Dummy%20Screen2/dummy_screen2.dart';
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
      DummyScreen1(),
      DummyScreen2(),
    ];
    List optionsText = [
      "Add a Product",
      "Assign an option",
      "Assign an option"
    ];
    return Scaffold(
      backgroundColor: ColorConstants.mainbg,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            SizedBox(
              height: 80,
            ),
            Text(
              "Select An Option",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Screens[index]));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        height: 80,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(width: 4, color: Colors.black)),
                        child: Row(
                          children: [
                            Text(
                              optionsText[index],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 20,
                    );
                  },
                  itemCount: 3),
            ),
          ],
        ),
      ),
    );
  }
}
