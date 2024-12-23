import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medicart/Utils/app_utils.dart';
import 'package:medicart/View/Admin%20Screens/Product%20Adding%20Screen/product_adding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminLoginScreenController with ChangeNotifier {
  bool isLoading = false;

  onAdminLogin(
      {required String username,
      required String password,
      required BuildContext context}) async {
    if (username.isNotEmpty && password.isNotEmpty) {
      isLoading = true;
      notifyListeners();
      try {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('admins')
            .where('username', isEqualTo: username)
            .where('password', isEqualTo: password)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          SharedPreferences adminprefs = await SharedPreferences.getInstance();
          await adminprefs.setBool('isAdminLoggedIn', true);

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => ProductAdding()),
            (route) => false,
          );
        } else {
          AppUtils.showSnackbar(
              context: context, message: "invalid username or password");
        }
      } catch (e) {
        print("Error: $e");
        AppUtils.showSnackbar(
            context: context, message: "An error occured. Try again!");
      }
    } else {
      AppUtils.showSnackbar(
          context: context, message: "Fields cannot be empty");
    }
    isLoading = false;
    notifyListeners();
  }
}
