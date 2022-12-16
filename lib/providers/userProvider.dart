import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thought/models/user.dart';
import 'package:thought/resources/authMethods.dart';
import 'package:thought/models/user.dart';
// import 'package:thoughts/models/user.dart';
import 'package:thought/resources/authMethods.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  final AuthMethods _authMethods = AuthMethods();
  UserModel? get getUser => _user;
  Future<void> refreshUser() async {
    try {
      UserModel user = await _authMethods.getUserDetails();
      _user = user;
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }
}
