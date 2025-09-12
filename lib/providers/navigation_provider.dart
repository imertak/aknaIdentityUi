import 'package:akna_ui/models/user_type.dart';
import 'package:flutter/material.dart';
import '../components/custom_bottom_navigation.dart';

class NavigationProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  UserType _userType = UserType.carrier;

  int get selectedIndex => _selectedIndex;
  UserType get userType => _userType;

  void setIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void setUserType(UserType type) {
    _userType = type;
    notifyListeners();
  }
}
