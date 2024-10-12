import 'package:flutter/material.dart';
import 'package:isHKolarium/config/constants/colors.dart'; // Adjust the import path to your project setup

class ViewAllText extends StatelessWidget {
  const ViewAllText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      "View All",
      style: TextStyle(
        fontSize: 11,
        fontFamily: 'Manrope',
        fontWeight: FontWeight.bold,
        color: ColorPalette.viewAllColor,
        letterSpacing: 0.5,
      ),
    );
  }
}
