

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medicart/Utils/app_utils.dart';
import 'package:medicart/View/Customer%20Screens/Login%20Screen/login_screen.dart';


class RegistrationScreenController with ChangeNotifier {
  bool isLoading = false;

 

  Future<void> onRegistration({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      isLoading = true;
      notifyListeners();

      try {
        //check for duplicate mail

        final QuerySnapshot = await FirebaseFirestore.instance
            .collection('customers')
            .where('email', isEqualTo: email)
            .get();

        if (QuerySnapshot.docs.isEmpty) {
          //email not exist create new ac
          await FirebaseFirestore.instance
              .collection('customers')
              .add({'email': email, 'password': password});

          AppUtils.showSnackbar(
              context: context,
              message: "Registration successful",
              bgcolor: Colors.green);

          //navigate to login screen

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ),(route) => false,
              );
        } else {
          //email already registered
          AppUtils.showSnackbar(
              context: context,
              message: "Email already registered",
              bgcolor: Colors.red);
        }
      } catch (e) {
        print(e);
        AppUtils.showSnackbar(context: context, message: "an error occured");
      }
      isLoading = false;
      notifyListeners();
    }else{
      AppUtils.showSnackbar(context: context, message: "Fields cannot be empty");
    }
  }
}
