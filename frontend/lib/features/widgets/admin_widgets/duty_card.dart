import 'package:flutter/material.dart';

class DutyCard extends StatelessWidget {
  final Color cardColor;
  final Color textColor;

  final dynamic content;

  final dynamic title;

  const DutyCard({
    super.key,
    required this.cardColor,
    required this.textColor,
    required this.title,
    required this.content,
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
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                fontFamily: 'Manrope',
                letterSpacing: 1.1,
                color: textColor,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              content,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
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
