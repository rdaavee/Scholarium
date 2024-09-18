import 'package:flutter/material.dart';
import 'package:isHKolarium/config/utils/theme/custom_themes/appbar_theme.dart';
import 'package:isHKolarium/config/utils/theme/custom_themes/checkbox_theme.dart';
import 'package:isHKolarium/config/utils/theme/custom_themes/chip_theme.dart';
import 'package:isHKolarium/config/utils/theme/custom_themes/elevated_button_theme.dart';
import 'package:isHKolarium/config/utils/theme/custom_themes/text_theme.dart';
import 'package:isHKolarium/config/utils/theme/custom_themes/textfield_theme.dart';

class TAppTheme {
  TAppTheme._(); //with underscore to become private

  //Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Montserrat',
    brightness: Brightness.light,
    primaryColor: const Color(0xFF6BA292),
    scaffoldBackgroundColor: const Color(0xFFE8E8E8),
    textTheme: TTextTheme.lightTextTheme,
    appBarTheme: TAppBarTheme.lightAppBarTheme,
    elevatedButtonTheme: TElevatedButtonTheme.LightElevatedButtonTheme,
    chipTheme: TChipTheme.lightChipTheme,
  
    checkboxTheme: TCheckboxTheme.lightCheckboxTheme,
    inputDecorationTheme: TTextFieldTheme.lightInputDecorationTheme,
  );

  //Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Montserrat',
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF6BA292),
    scaffoldBackgroundColor: const Color(0xFF222831),
    textTheme: TTextTheme.darkTextTheme,
    appBarTheme: TAppBarTheme.darkAppBarTheme,
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
    chipTheme: TChipTheme.darkChipTheme,
    checkboxTheme: TCheckboxTheme.darkCheckboxTheme,
    inputDecorationTheme: TTextFieldTheme.darkInputDecorationTheme,
  );
}
