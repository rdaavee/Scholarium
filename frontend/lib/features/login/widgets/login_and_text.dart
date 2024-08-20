import 'package:flutter/material.dart';

class LogoAndText extends StatelessWidget {
  const LogoAndText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Image.asset(
          'assets/images/logo_college.png',
          height: 150.0,
          width: 150.0,
        ),
        SizedBox(height: 10),
        Text(
          'Welcome to isHKolarium',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text(
          'Sign in to continue',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
