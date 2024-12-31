import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicart/Controller/Login%20Screen%20Controller/login_screen_state.dart';
import 'package:medicart/Utils/app_utils.dart';
import 'package:medicart/View/Customer%20Screens/Custom%20Bottom%20Navbar%20Screen/custom_bottom_navbar_screen.dart';
import 'package:medicart/View/Customer%20Screens/Personal%20Details%20Adding%20Screen/personal_details_adding_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

final LoginScreenStateNotifierProvider =
    StateNotifierProvider((ref) => LoginScreenController());

class LoginScreenController extends StateNotifier<LoginScreenState> {
  LoginScreenController() : super(LoginScreenState());

  Future<void> onLogin(
      {required String email,
      required String password,
      required BuildContext context}) async {
    state = state.copywith(isloading: true);

    try {
      final credentials = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      //get the uid
      String uid = credentials.user!.uid;

      //fetch the role
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('roles').doc(uid).get();

      //check the role
      if (userDoc.exists) {
        String role = userDoc['role'];
        log(role);
        bool isProfileDetailsAdded = userDoc['isProfileDetailsAdded'];


        if (role == 'user') {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          if (isProfileDetailsAdded) {
            // Navigate to Admin HomeScreen
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => CustomBottomNavbarScreen()));
          } else {
            // Navigate to User HomeScreen
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => PersonalDetailsAddingScreen()));
          }

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CustomBottomNavbarScreen()));
        } else if (role == 'admin') {
          AppUtils.showSnackbar(
              context: context, message: "please enter correct details");
        }
      }
    } on FirebaseAuthException catch (e) {
      log(e.toString());
      if (e.code == 'invalid-email') {
        AppUtils.showSnackbar(
            context: context, message: "No user found for that email.");
      } else if (e.code == 'wrong-password') {
        AppUtils.showSnackbar(
            context: context,
            message: "Wrong password provided for that user.");
      }
    } catch (e) {
      log(e.toString());
      AppUtils.showSnackbar(context: context, message: e.toString());
    }
    state = state.copywith(isloading: false);
  }
}
