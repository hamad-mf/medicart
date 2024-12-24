import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryScreenController with ChangeNotifier {
  List<String> categories = [];

  fetchCategories() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('products').get();

      final allCategories = querySnapshot.docs
          .map((doc) => doc['category'] as String) // Correctly access 'category'
          .toSet() // Remove duplicates
          .toList();

      categories = allCategories;
      print("Categories fetched successfully: $categories");
      notifyListeners(); // Notify listeners to update the UI
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }
}
