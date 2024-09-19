import 'package:flutter/material.dart';
import 'package:isHKolarium/config/constants/colors.dart';

class AccountSection extends StatelessWidget {
  const AccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 16.0),
      width: double.infinity,
      height: 51,
      decoration: BoxDecoration(
        color: ColorPalette.accent.withOpacity(0.4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        'ACCOUNT',
        style: TextStyle(
          color: ColorPalette.primary,
          fontSize: 15,
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
