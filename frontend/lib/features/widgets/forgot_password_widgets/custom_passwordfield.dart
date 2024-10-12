import 'package:flutter/material.dart';

class CustomPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final Color borderColor;
  final Color focusedBorderColor;
  final Color hoverColor;
  final double borderRadius;

  const CustomPasswordField({
    super.key,
    required this.controller,
    required this.labelText,
    this.obscureText = true,
    this.borderColor = Colors.grey,
    this.focusedBorderColor = const Color(0xFF00A4E4),
    this.hoverColor = const Color(0xFF00A4E4),
    this.borderRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Colors.grey,
          fontFamily: 'Manrope',
          fontSize: 13,
        ),
        floatingLabelStyle: const TextStyle(
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
          borderRadius: BorderRadius.circular(12.0),
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
    );
  }
}
