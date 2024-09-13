import 'package:flutter/material.dart';

class TElevatedButtonTheme {
  TElevatedButtonTheme._(); //to avoid creating instances

  static final LightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        elevation: 0,
        foregroundColor: Colors.white,
        disabledForegroundColor: Colors.grey,
        backgroundColor: const Color(0xFF6BA292),
        disabledBackgroundColor: Colors.grey,
        side: const BorderSide(color: Color(0xFF6BA292)),
        padding: const EdgeInsets.symmetric(vertical: 18),
        textStyle: const TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        )),
  );

  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        elevation: 0,
        foregroundColor: Colors.white,
        disabledForegroundColor: Colors.grey,
        backgroundColor: const Color(0xFF6BA292),
        disabledBackgroundColor: Colors.grey,
        side: const BorderSide(color: Color(0xFF6BA292)),
        padding: const EdgeInsets.symmetric(vertical: 18),
        textStyle: const TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        )),
  );
}
