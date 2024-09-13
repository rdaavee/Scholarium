import 'package:flutter/material.dart';
import 'package:isHKolarium/config/constants/colors.dart';

class SignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  const SignInButton({required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorPalette.primary,
        side: BorderSide(
          color: ColorPalette.primary,
        ),
        minimumSize: Size(287, 55),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
      child: Text(
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
