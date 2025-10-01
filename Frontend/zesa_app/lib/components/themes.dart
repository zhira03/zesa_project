import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme(){
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setTheme(bool isDarkMode){
    _isDarkMode = isDarkMode;
    notifyListeners();
  }

  ThemeData get currentTheme{
    return _isDarkMode ? ThemeData.dark() : ThemeData.light();
  }
}