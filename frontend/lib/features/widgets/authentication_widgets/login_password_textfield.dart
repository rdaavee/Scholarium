import 'package:flutter/material.dart';
import 'package:isHKolarium/blocs/bloc_authentication/authentication_bloc.dart';

class PasswordField extends StatefulWidget {
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
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 287,
      height: 55,
      child: TextField(
        controller: widget.passwordController,
        obscureText: _obscureText,
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
            borderSide: const BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(
              color: Color(0xFF00A4E4),
              width: 2,
            ),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
              size: 13,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
        ),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 12.0,
          fontWeight: FontWeight.w300,
        ),
        onSubmitted: (value) {
          widget.loginBloc.add(
            LoginButtonClickedEvent(
              widget.schoolIdController.text,
              widget.passwordController.text,
            ),
          );
        },
      ),
    );
  }
}
