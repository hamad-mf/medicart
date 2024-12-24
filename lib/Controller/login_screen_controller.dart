import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:medicart/Utils/app_utils.dart';
import 'package:medicart/View/Customer%20Screens/Custom%20BottomNavBar/custom_bottom_navbar.dart';



import 'package:shared_preferences/shared_preferences.dart';

class LoginScreenController with ChangeNotifier {
  bool isLoading = false;
  

  onLogin(
      {required String email,
      required String password,
      required BuildContext context}) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      isLoading = true;
      notifyListeners();
      try {
        // Query Firestore to verify credentials
        final querySnapshot = await FirebaseFirestore.instance
            .collection('customers')
            .where('email', isEqualTo: email)
            .where('password', isEqualTo: password)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Retrieve the first document's ID (assuming one user per email)
          String docId = querySnapshot.docs.first.id;
          print('Document ID: $docId');
          SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('docId', docId);
      print('Login successful, docId saved: $docId'); // Store docId for future use
          // Valid credentials: navigate to SampleScreen
         
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => CustomBottomNavbar(),

            ),(route) => false,
          );
        } else {
          // Invalid credentials: Show error dialog
          AppUtils.showSnackbar(
            context: context, message: "Invalid email or password!");
          // _showErrorDialog(context, "Invalid email or password!");
        }
      } catch (e) {
        print('Error: $e');
        AppUtils.showSnackbar(
            context: context, message: "An error occurred. Try again!");
        // _showErrorDialog(context, "An error occurred. Try again!");
      }

    } else {
       AppUtils.showSnackbar(
            context: context, message: "Fields cannot be empty!");
      // _showErrorDialog(context, "Fields cannot be empty!");
    }
    isLoading = false;
    notifyListeners();
  }

 
}
