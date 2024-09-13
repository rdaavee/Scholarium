import 'package:flutter/material.dart';

class LogoAndText extends StatelessWidget {
  const LogoAndText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 10),
        Text(
          'Login your account',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6D7278),
          ),
        ),
      ],
    );
  }
}
