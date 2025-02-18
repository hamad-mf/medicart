import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicart/Controller/Admin%20Login%20Screen%20Controller/admin_login_screen_state.dart';
import 'package:medicart/Utils/app_utils.dart';
import 'package:medicart/View/Admin%20Screens/Admin%20Home%20Screen/admin_home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

final AdminLoginScreenStateNotifierProvider =
    StateNotifierProvider((ref) => AdminLoginScreenController());

class AdminLoginScreenController extends StateNotifier<AdminLoginScreenState> {
  AdminLoginScreenController() : super(AdminLoginScreenState());

  Future<void> onAdminLogin(
      {required String email,
      required String password,
      required BuildContext context}) async {
    state = state.copywith(isloading: true);

    try {
      final admincredentials = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      //get the uid
      String uid = admincredentials.user!.uid;

      //fetch the role
      DocumentSnapshot admindoc =
          await FirebaseFirestore.instance.collection('roles').doc(uid).get();

      //check the role
      if (admindoc.exists) {
        String role = admindoc['role'];
        log(role);
        if (role == 'admin') {

          log("navigated");
          SharedPreferences adminprefs = await SharedPreferences.getInstance();
          await adminprefs.setBool('isAdminLoggedIn', true);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AdminHomeScreen()));
        } else if (role == 'user' || role == 'doctor') {
          AppUtils.showSnackbar(
              context: context, message: "Enter correct details");
        }
      }
    } on FirebaseAuthException catch (e) {
      log(e.toString());
      if (e.code == 'invalid-email') {
        AppUtils.showSnackbar(context: context, message: "invalid credentials");
      } else if (e.code == 'wrong-password') {
        AppUtils.showSnackbar(context: context, message: "invalid credentials");
      }
    } catch (e) {
      log(e.toString());
      AppUtils.showSnackbar(context: context, message: "an error occured");
    }
    state = state.copywith(isloading: false);
  }
}
