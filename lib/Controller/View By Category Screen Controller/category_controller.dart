import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicart/Controller/View%20By%20Category%20Screen%20Controller/category_state.dart';

class CategoryController extends StateNotifier<CategoryState> {
  CategoryController() : super(const CategoryState());

  Future<void> fetchCategories() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('products').get();

      final allCategories = querySnapshot.docs
          .map((doc) => doc['category'] as String)
          .toSet() // Remove duplicates
          .toList();

      state = state.copyWith(categories: allCategories, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to fetch categories: $e',
      );
    }
  }
}