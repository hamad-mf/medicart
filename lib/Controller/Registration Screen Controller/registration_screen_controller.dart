import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicart/Controller/Registration%20Screen%20Controller/registration_screen_state.dart';
import 'package:medicart/Utils/app_utils.dart';

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
      // Create a new user with email and password
      final credentials = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Get the UID of the created user
      String uid = credentials.user!.uid;

      // Store the user role in the 'roles' collection
      await FirebaseFirestore.instance
          .collection('roles')
          .doc(uid)
          .set({'role': role, 'isProfileDetailsAdded': false});

      
  if (role =='user') {
     // Initialize an empty cart for the specific user
      await FirebaseFirestore.instance
          .collection('cart')
          .doc(uid)
          .set({'created_at': DateTime.now(), 'total_price': 0});
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(uid)
          .set({'created_at': DateTime.now(),});
       await FirebaseFirestore.instance
          .collection('prescriptions')
          .doc(uid)
          .set({'created_at': DateTime.now(), 'status': false,'user_id':uid});


  }
      // Notify user about registration success
      AppUtils.showSnackbar(
          context: context,
          message: "Registration Success",
          bgcolor: Colors.green);
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific exceptions
      if (e.code == 'weak-password') {
        AppUtils.showSnackbar(
            context: context, message: "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        AppUtils.showSnackbar(
            context: context,
            message: "The account already exists for that email.");
      } else if (e.code == 'network-request-failed') {
        AppUtils.showSnackbar(
            context: context, message: "Please check your network.");
      }
    } catch (e) {
      // Handle general exceptions
      log(e.toString());
      AppUtils.showSnackbar(context: context, message: e.toString());
    }

    state = state.copywith(isloading: false);
  }
}
