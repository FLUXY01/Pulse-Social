import 'package:flutter/material.dart';
import 'package:pulse_social/models/user.dart';
import 'package:pulse_social/resources/auth_method.dart';

class UserProvider with ChangeNotifier{
  User? _user;
  final AuthMethod _authMethod = AuthMethod();

  User get getUser => _user!;

  Future<void> refreshUser() async{
    User user = await _authMethod.getUserDetail();
    _user = user;
    notifyListeners();
  }
}