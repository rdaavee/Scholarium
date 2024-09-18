import 'package:flutter/material.dart';
import 'package:isHKolarium/config/constants/colors.dart';

class ScheduleHeader extends StatelessWidget {
  const ScheduleHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0),
      child: Container(
        height: 100.0,
        color: ColorPalette.primary,
        alignment: Alignment.centerLeft,
        child: const Text(
          "Schedule",
          style: TextStyle(
            fontSize: 17,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
      ),
    );
  }
}
