import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicart/Utils/app_utils.dart';

class LoginScreenController with ChangeNotifier {
  bool isLoading = false;
  onLogin(
      {required String email,
      required String password,
      required BuildContext context}) async {
    isLoading = true;
    notifyListeners();
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      log("login success");
      AppUtils.showSnackbar(
          context: context, message: "login success", bgcolor: Colors.green);
      log(credential.user?.email.toString() ?? "no data");
    } on FirebaseAuthException catch (e) {
      log(e.code.toString());
      if (e.code == 'invalid-email') {
        log("no user found for that emqil");
        AppUtils.showSnackbar(
            context: context, message: "no user found for that email");
      } else if (e.code == 'wrong-password') {
        log("please check the passwiord");
        AppUtils.showSnackbar(
            context: context, message: "please check the passwiord");
      } else if (e.code == 'invalid-credential') {
        log("please check the password/email");
        AppUtils.showSnackbar(
            context: context, message: "please check the passwiord/email");
      }
    } catch (e) {
      print(e);
    }
    isLoading = false;
    notifyListeners();
  }
}
