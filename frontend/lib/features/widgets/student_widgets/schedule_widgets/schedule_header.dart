import 'package:flutter/material.dart';
import 'package:isHKolarium/config/constants/colors.dart';

class ScheduleHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0),
      child: Container(
        height: 100.0,
        color: ColorPalette.primary,
        alignment: Alignment.centerLeft,
        child: Text(
          "Schedule",
          style: TextStyle(
            fontSize: 17,
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
      ),
    );
  }
}
