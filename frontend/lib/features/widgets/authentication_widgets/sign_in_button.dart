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
        backgroundColor: ColorPalette.btnColor,
        side: const BorderSide(
          color: ColorPalette.btnColor,
        ),
        minimumSize: const Size(287, 45),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
      child: const Text(
        'Sign In',
        style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.normal,
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }
}
