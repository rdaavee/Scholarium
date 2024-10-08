import 'package:flutter/material.dart';

class DutyCard extends StatelessWidget {
  final Color cardColor;
  final String time;
  final String roomName;
  final Color textColor;

  const DutyCard({
    super.key,
    required this.cardColor,
    required this.time,
    required this.roomName,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Facilitator Duty',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                fontFamily: 'Manrope',
                letterSpacing: 1.1,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
