import 'package:flutter/material.dart';
import 'package:isHKolarium/config/constants/strings.dart';

class EmailValidator extends StatelessWidget {
  const EmailValidator({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter an email';
        }
        // Combine the list into a single regex pattern
        String pattern = ScholariumStrings.emailValidation.join('|');
        RegExp regExp = RegExp(pattern);
        // Validate the email
        if (!regExp.hasMatch(value)) {
          return 'Invalid email address';
        }
        return null;
      },
    );
  }
}
