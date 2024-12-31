import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicart/Controller/Personal%20Details%20Adding%20Screen%20Controller/personal_details_adding_screen_state.dart';
import 'package:medicart/Utils/app_utils.dart';
import 'package:medicart/View/Customer%20Screens/Custom%20Bottom%20Navbar%20Screen/custom_bottom_navbar_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

final PersonalDetailsAddingScreenStateNotifeirProvider =
    StateNotifierProvider((ref) => PersonalDetailsAddingScreenController());

class PersonalDetailsAddingScreenController
    extends StateNotifier<PersonalDetailsAddingScreenState> {
  PersonalDetailsAddingScreenController()
      : super(PersonalDetailsAddingScreenState());

  Future<void> onAddDetails({
    required String full_name,
    required String email,
    required num phn,
    required Map<String, dynamic> shipping_adress,
    required BuildContext context,
  }) async {
    state = state.copywith(isloading: true);
    String? uid;
    try {
      final User? user =
          FirebaseAuth.instance.currentUser; // Get the current user

      if (user != null) {
        uid = user.uid;
        log(uid);
      } else {
        log("no user logged in");
      }

      await FirebaseFirestore.instance
          .collection('profile_details')
          .doc(uid)
          .set({
        'email': email,
        'full_name': full_name,
        'phn': phn,
        'shipping_address': shipping_adress
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isProfiledetailsAdded', true);

      
      AppUtils.showSnackbar(context: context, message: "Details Added");
       Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CustomBottomNavbarScreen()));
    } catch (e) {
      print(e);
      log(e.toString());
      AppUtils.showSnackbar(context: context, message: e.toString());
    }
    state = state.copywith(isloading: false);
  }
}
