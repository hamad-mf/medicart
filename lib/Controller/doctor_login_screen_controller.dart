import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medicart/Utils/app_utils.dart';
import 'package:medicart/View/Doctor%20Screens/Home%20Screen/doctor_home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorLoginScreenController with ChangeNotifier {
  bool isLoading = false;

  onDoctorLogin(
      {required String username,
      required String password,
      required BuildContext context}) async {
    if (username.isNotEmpty && password.isNotEmpty) {
      isLoading = true;
      notifyListeners();
      try {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('doctors')
            .where('username', isEqualTo: username)
            .where('password', isEqualTo: password)
            .get();
        if (querySnapshot.docs.isNotEmpty) {
          SharedPreferences doctorprefs = await SharedPreferences.getInstance();
          await doctorprefs.setBool('isDoctorLoggedIn', true);

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => DoctorHomeScreen()),
            (route) => false,
          );
        } else {
          AppUtils.showSnackbar(
              context: context, message: "Invalid username or password");
        }
      } catch (e) {
        print("Error: $e");
        AppUtils.showSnackbar(context: context, message: "An error occured. Try again!");
      }
    }else {
      AppUtils.showSnackbar(
          context: context, message: "Fields cannot be empty");
    }
    isLoading = false;
    notifyListeners();
  }
}
