import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:medicart/Utils/app_utils.dart';

import 'package:medicart/View/Home%20Screen/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreenController with ChangeNotifier {
  bool isLoading = false;
  // onLogin(
  //     {required String email,
  //     required String password,
  //     required BuildContext context}) async {
  //   isLoading = true;
  //   notifyListeners();
  //   try {
  //     final credential = await FirebaseAuth.instance
  //         .signInWithEmailAndPassword(email: email, password: password);
  //     log("login success");
  //     AppUtils.showSnackbar(
  //         context: context, message: "login success", bgcolor: Colors.green);
  //     log(credential.user?.email.toString() ?? "no data");
  //   } on FirebaseAuthException catch (e) {
  //     log(e.code.toString());
  //     if (e.code == 'invalid-email') {
  //       log("no user found for that emqil");
  //       AppUtils.showSnackbar(
  //           context: context, message: "no user found for that email");
  //     } else if (e.code == 'wrong-password') {
  //       log("please check the passwiord");
  //       AppUtils.showSnackbar(
  //           context: context, message: "please check the passwiord");
  //     } else if (e.code == 'invalid-credential') {
  //       log("please check the password/email");
  //       AppUtils.showSnackbar(
  //           context: context, message: "please check the passwiord/email");
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  //   isLoading = false;
  //   notifyListeners();
  // }

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
          SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
          // Valid credentials: navigate to SampleScreen
          Navigator.of(context).pop(); // Close bottom sheet
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
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

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
