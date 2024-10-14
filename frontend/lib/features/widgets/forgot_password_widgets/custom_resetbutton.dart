import 'package:flutter/material.dart';

class CustomResetButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final double borderRadius;
  final Size minimumSize;

  const CustomResetButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
    this.backgroundColor = const Color(0xFF00A4E4), // Default primary color
    this.textColor = Colors.white,
    this.fontSize = 11.5,
    this.borderRadius = 8.0,
    this.minimumSize = const Size(360, 55),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        minimumSize: minimumSize,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      onPressed: onPressed,
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
