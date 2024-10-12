import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextStyle? labelStyle;
  final TextStyle? floatingLabelStyle;
  final TextStyle? textStyle;
  final Color borderColor;
  final Color focusedBorderColor;
  final Color hoverColor;
  final double borderRadius;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.labelStyle,
    this.floatingLabelStyle,
    this.textStyle,
    this.borderColor = Colors.grey,
    this.focusedBorderColor = const Color(0xFF00A4E4), // Default primary color
    this.hoverColor = const Color(0xFF00A4E4), // Default primary color
    this.borderRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: labelStyle ??
            const TextStyle(
              color: Colors.grey,
              fontFamily: 'Manrope',
              fontSize: 13,
            ),
        floatingLabelStyle: floatingLabelStyle ??
            const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00A4E4),
            ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: focusedBorderColor,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor),
        ),
        hoverColor: hoverColor,
      ),
      style: textStyle ??
          const TextStyle(
            color: Colors.black,
            fontFamily: 'Manrope',
            fontSize: 13,
          ),
    );
  }
}
