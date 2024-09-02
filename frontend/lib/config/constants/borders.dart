import 'package:flutter/material.dart';
import 'package:isHKolarium/config/constants/colors.dart';

class Inputs {
  static OutlineInputBorder enabledBorder = OutlineInputBorder(
    borderSide: const BorderSide(
      color: ColorPalette.accent,
      width: 1.5,
    ),
    borderRadius: BorderRadius.circular(8.0),
  );

  static OutlineInputBorder focusedBorder = OutlineInputBorder(
    borderSide: const BorderSide(
      color: ColorPalette.primary,
      width: 2.3,
    ),
    borderRadius: BorderRadius.circular(8.0),
  );

  static OutlineInputBorder errorBorder = OutlineInputBorder(
    borderSide: const BorderSide(
      color: ColorPalette.errorColor,
      width: 2,
    ),
    borderRadius: BorderRadius.circular(8.0),
  );
}
