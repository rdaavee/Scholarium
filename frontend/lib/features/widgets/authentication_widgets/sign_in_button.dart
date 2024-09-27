import 'package:flutter/material.dart';
import 'package:isHKolarium/config/constants/colors.dart';

class SignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  const SignInButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 287,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorPalette.btnColor,
          side: const BorderSide(
            color: ColorPalette.btnColor,
          ),
          minimumSize: const Size(287, 45),
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
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
      ),
    );
  }
}
