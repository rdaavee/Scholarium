import 'package:flutter/material.dart';
import 'package:isHKolarium/config/constants/colors.dart';

class InfoHeader extends StatelessWidget {
  final String title;

  const InfoHeader({required this.title, super.key});

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
      child: Text(
        title,
        style: const TextStyle(
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
