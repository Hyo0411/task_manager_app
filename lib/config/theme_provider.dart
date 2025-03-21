import 'package:flutter/material.dart';
import 'package:task_manager_app/config/theme.dart';

class ThemeProvider with ChangeNotifier{
  ThemeData _themeData = lightMode;
  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData){
    _themeData = themeData;
    notifyListeners();
  }

  void handleChangeTheme(){
    if (_themeData == lightMode) {
      themeData = darktMode;
    }else{
      themeData = lightMode;
    }
  }
}