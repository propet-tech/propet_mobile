import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:propet_mobile/core/services/auth_service.dart';
import 'package:propet_mobile/models/userinfo/userinfo.dart';
import 'package:propet_mobile/services/user_service.dart';

@Singleton()
class AppState extends ChangeNotifier {
  
  final AuthService _auth;
  final UserService _user;

  UserInfo? userinfo;

  AppState(this._auth, this._user);

  Future<void> login() async {
    await _auth.login();
    userinfo = await _user.getUserInfo();
    notifyListeners();
  }

  Future<void> logout() async {
    await _auth.logout();
    notifyListeners();
  }

  Future<void> autoLogin() async { 
    await _auth.autoLogin();
    userinfo = await _user.getUserInfo();
    notifyListeners();
  }

}
