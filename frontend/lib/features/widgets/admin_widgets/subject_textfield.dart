import 'package:flutter/material.dart';

class SubjectTextfield extends StatelessWidget {
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
  final TextEditingController subjectController;

  const SubjectTextfield({
    super.key,
    required this.labelText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.labelStyle,
    this.floatingLabelStyle,
    this.textStyle,
    this.borderColor = Colors.grey,
    this.focusedBorderColor = const Color(0xFF00A4E4),
    this.hoverColor = const Color(0xFF00A4E4),
    this.borderRadius = 8.0,
    required this.subjectController,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: subjectController,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: labelStyle ??
            const TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
        floatingLabelStyle: floatingLabelStyle ??
            const TextStyle(
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
            fontSize: 13,
          ),
    );
  }
}
