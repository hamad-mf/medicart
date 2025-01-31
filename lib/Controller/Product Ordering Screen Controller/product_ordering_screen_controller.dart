import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider to get the current user's UID
final userUIDProvider = Provider<String?>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  return user?.uid;
});

// Provider for the dropdown value
final dropdownValueProvider = StateProvider<String?>((ref) => null);

// List of countries for the dropdown
final qnt = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];

// Stream provider for fetching profile details
final profileDetailsProvider =
    StreamProvider.family<DocumentSnapshot<Map<String, dynamic>>?, String>(
        (ref, uid) {
  return FirebaseFirestore.instance
      .collection('profile_details')
      .doc(uid)
      .snapshots();
});
