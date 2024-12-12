import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:medicart/Utils/app_utils.dart';
import 'package:medicart/View/Login%20Screen/login_screen.dart';

class RegistrationScreenController with ChangeNotifier {
  bool isLoading = false;

  Future<void> onRegistration(
      {required String email,
      required String password,
      required BuildContext context}) async {
    isLoading = true;
    notifyListeners();
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (credential.user?.uid != null) {
        AppUtils.showSnackbar(
            bgcolor: Colors.green,
            context: context,
            message: "Account Created Successfully");
             
      await FirebaseAuth.instance.signOut();
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false,);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'week-password') {
        AppUtils.showSnackbar(
            context: context, message: "The Password provided is too week");
      } else if (e.code == 'email-already-in-use') {
        AppUtils.showSnackbar(
            context: context, message: "The email already registered");
      }
    } catch (e) {
      print(e);
      AppUtils.showSnackbar(context: context, message: e.toString());
    }
    isLoading = false;
    notifyListeners();
  }
}
