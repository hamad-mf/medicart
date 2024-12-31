import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicart/Controller/Registration%20Screen%20Controller/registration_screen_state.dart';
import 'package:medicart/Utils/app_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

final RegistrationScreenStateNotifierProvider =
    StateNotifierProvider((ref) => RegistrationScreenController());

class RegistrationScreenController
    extends StateNotifier<RegistrationScreenState> {
  RegistrationScreenController() : super(RegistrationScreenState());

  Future<void> onRegistration({
    required String email,
    required String password,
    required String role,
    required BuildContext context,
  }) async {
    state = state.copywith(isloading: true);
    try {
      final credentials = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      //get the uid
      String uid = credentials.user!.uid;

      //store the role
      await FirebaseFirestore.instance
          .collection('roles')
          .doc(uid)
          .set({'role': role,'isProfileDetailsAdded':false});
      if (credentials.user?.uid != null) {
       
        AppUtils.showSnackbar(
            context: context, message: "registration success");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'week-password') {
        AppUtils.showSnackbar(
            context: context, message: "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        AppUtils.showSnackbar(
            context: context,
            message: "The account already exists for that email.");
      } else if (e.code == 'network-request-failed') {
        AppUtils.showSnackbar(
            context: context, message: "please check your network");
      }
    } catch (e) {
      print(e);
      log(e.toString());
      AppUtils.showSnackbar(context: context, message: e.toString());
    }
    state = state.copywith(isloading: false);
  }
}
