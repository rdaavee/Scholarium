import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final double borderRadius;
  final Size minimumSize;

  const SubmitButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.backgroundColor = const Color(0xFF00A4E4),
    this.textColor = Colors.white,
    this.fontSize = 11.5,
    this.borderRadius = 8.0,
    this.minimumSize = const Size(360, 55),
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        minimumSize: minimumSize,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: Text(
        buttonText,
        style: TextStyle(
          fontSize: fontSize,
          color: textColor,
        ),
      ),
    );
  }
}
