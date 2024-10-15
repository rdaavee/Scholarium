import 'package:flutter/material.dart';
import 'package:isHKolarium/blocs/bloc_authentication/authentication_bloc.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController schoolIdController;
  final TextEditingController passwordController;
  final AuthenticationBloc loginBloc;

  const PasswordField({
    super.key,
    required this.schoolIdController,
    required this.passwordController,
    required this.loginBloc,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 287,
      height: 55,
      child: TextField(
        controller: passwordController,
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'Password',
          labelStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 13,
          ),
          floatingLabelStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00A4E4),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.2),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: const Color(0xFF00A4E4),
              width: 2,
            ),
          ),
        ),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 12.0,
          fontWeight: FontWeight.w300,
        ),
        onSubmitted: (value) {
          loginBloc.add(
            LoginButtonClickedEvent(
              schoolIdController.text,
              passwordController.text,
            ),
          );
        },
      ),
    );
  }
}
