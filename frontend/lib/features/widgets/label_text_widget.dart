import 'package:flutter/material.dart';

class LabelTextWidget extends StatelessWidget {
  final String title;
  final double fontSize;
  final Color color;

  const LabelTextWidget({
    super.key,
    required this.title,
    this.fontSize = 15.0,
    this.color = const Color(0xFF6D7278),
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: color,
        letterSpacing: 0.5,
      ),
    );
  }
}
