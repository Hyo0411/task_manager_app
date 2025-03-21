import 'package:flutter/material.dart';

  ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(background: Colors.white),
    primaryColor: Colors.grey.shade700,
  );

  ThemeData darktMode = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(background: Colors.grey.shade700),
    primaryColor: Colors.white,
  );
