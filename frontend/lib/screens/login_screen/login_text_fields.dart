import 'package:flutter/material.dart';
import 'package:isHKolarium/constants/paddings.dart';
import 'package:isHKolarium/constants/strings.dart';

Widget buildEmailTextField(
  BuildContext context,
  InputDecorationTheme inputDecorationTheme,
  TextEditingController schoolIdController,
) {
  return TextFormField(
    controller: schoolIdController,
    textAlign: TextAlign.start,
    keyboardType: TextInputType.emailAddress,
    decoration: InputDecoration(
      prefixIconColor: inputDecorationTheme.prefixIconColor,
      suffixIconColor: inputDecorationTheme.suffixIconColor,
      labelStyle: inputDecorationTheme.labelStyle,
      hintStyle: inputDecorationTheme.hintStyle,
      errorStyle: inputDecorationTheme.errorStyle,
      floatingLabelStyle: inputDecorationTheme.floatingLabelStyle,
      enabledBorder: inputDecorationTheme.enabledBorder,
      focusedBorder: inputDecorationTheme.focusedBorder,
      errorBorder: inputDecorationTheme.errorBorder,
      focusedErrorBorder: inputDecorationTheme.focusedErrorBorder,
      labelText: 'Email',
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter an email';
      }

      String pattern = ScholariumStrings.emailValidation.join('|');
      RegExp regExp = RegExp(pattern);

      if (!regExp.hasMatch(value)) {
        return 'Invalid email address';
      }
      return null;
    },
  );
}

Widget buildPasswordTextField(
    BuildContext context,
    InputDecorationTheme inputDecorationTheme,
    bool passwordVisible,
    VoidCallback onTogglePasswordVisibility,
    TextEditingController passwordController) {
  return TextFormField(
    controller: passwordController,
    obscureText: passwordVisible,
    textAlign: TextAlign.start,
    keyboardType: TextInputType.visiblePassword,
    decoration: InputDecoration(
      prefixIconColor: inputDecorationTheme.prefixIconColor,
      suffixIconColor: inputDecorationTheme.suffixIconColor,
      labelStyle: inputDecorationTheme.labelStyle,
      hintStyle: inputDecorationTheme.hintStyle,
      errorStyle: inputDecorationTheme.errorStyle,
      floatingLabelStyle: inputDecorationTheme.floatingLabelStyle,
      enabledBorder: inputDecorationTheme.enabledBorder,
      focusedBorder: inputDecorationTheme.focusedBorder,
      errorBorder: inputDecorationTheme.errorBorder,
      focusedErrorBorder: inputDecorationTheme.focusedErrorBorder,
      labelText: 'Password',
      suffixIcon: IconButton(
        onPressed: onTogglePasswordVisibility,
        icon: Icon(
          passwordVisible
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
        ),
        iconSize: defaultPadding,
      ),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter your password';
      }
      if (value.length < 5) {
        return 'Your password must be more than 5 characters';
      }
      return null;
    },
  );
}
