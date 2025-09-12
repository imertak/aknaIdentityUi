import 'package:flutter/material.dart';
import '../models/user_type.dart';

class UserDataProvider extends ChangeNotifier {
  String _userName = "";
  UserType _userType = UserType.carrier; // Default value

  String get userName => _userName;
  UserType get userType => _userType;
  String get userTypeStr => _userType.toDisplayString();

  void setUserData(String name, UserType type) {
    _userName = name;
    _userType = type;
    notifyListeners();
  }

  void setUserDataFromStrings(String name, String type) {
    _userName = name;
    _userType = UserType.fromString(type);
    notifyListeners();
  }
}
