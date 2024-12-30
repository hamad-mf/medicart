import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicart/Controller/Doctor%20Login%20Screen%20Controller/doctor_login_screen_state.dart';
import 'package:medicart/Utils/app_utils.dart';
import 'package:medicart/View/Doctor%20Screens/Doctor%20Home%20Screen/doctor_home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

final DoctorLoginScreenStateNotifierProvider =
    StateNotifierProvider((ref) => DoctorLoginScreenController());

class DoctorLoginScreenController
    extends StateNotifier<DoctorLoginScreenState> {
  DoctorLoginScreenController() : super(DoctorLoginScreenState());

  Future<void> onDoctorLogin(
      {required String email,
      required String password,
      required BuildContext context}) async {
    state = state.copywith(isloading: true);

    try {
      final doctorcredentials = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      //get the uid
      String uid = doctorcredentials.user!.uid;

      //fetch the role
      DocumentSnapshot doctorDoc =
          await FirebaseFirestore.instance.collection('roles').doc(uid).get();

      //check the role
      if (doctorDoc.exists) {
        String role = doctorDoc['role'];
        log(role);
        if (role == 'doctor') {
          log("navigated");
          SharedPreferences doctorprefs = await SharedPreferences.getInstance();
          await doctorprefs.setBool('isDoctorLoggedIn', true);

          Navigator.push(context,
              MaterialPageRoute(builder: (context) => DoctorHomeScreen()));
        } else if (role == 'user' || role == 'admin') {
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
