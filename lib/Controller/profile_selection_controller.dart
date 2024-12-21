import 'package:flutter/material.dart';

class ProfileSelectionController with ChangeNotifier {
   String? _selectedRole;

  String? get selectedRole => _selectedRole;

  // Update selected role
  void selectRole(String role) {
    _selectedRole = role;
    notifyListeners(); // Notify listeners of state change
  }

  // Clear selection
  void clearSelection() {
    _selectedRole = null;
    notifyListeners(); // Notify listeners of state change
  }

  // Check if a role is selected
  bool get isRoleSelected => _selectedRole != null;
}