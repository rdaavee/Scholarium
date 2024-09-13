import 'package:flutter/material.dart';
import 'package:isHKolarium/config/constants/colors.dart';

class SignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  const SignInButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorPalette.primary,
        side: const BorderSide(
          color: ColorPalette.primary,
        ),
        minimumSize: const Size(287, 55),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
      child: const Text(
        'Sign In',
        style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.normal,
          fontSize: 12,
        ),
      ),
    );
  }
}
