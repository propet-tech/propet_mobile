import 'package:flutter/material.dart';

class AppConfig extends ChangeNotifier {
  
  ThemeMode mode = ThemeMode.system;

  void changeTheme(ThemeMode mode) {
    this.mode = mode;
    notifyListeners();
  }
}
