import 'package:flutter/material.dart';

class DutyCard extends StatelessWidget {
  final Color cardColor;
  final Color textColor;
  final String title;
  final String content;
  final IconData icon;

  const DutyCard({
    super.key,
    required this.cardColor,
    required this.textColor,
    required this.title,
    required this.content,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: Card(
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 40,
                color: textColor,
              ),
              SizedBox(height: 12.0),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Manrope',
                  color: textColor,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                content,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Manrope',
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
