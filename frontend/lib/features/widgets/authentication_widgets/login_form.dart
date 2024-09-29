import 'package:flutter/material.dart';
import 'package:isHKolarium/blocs/bloc_authentication/authentication_bloc.dart';
import 'package:isHKolarium/features/widgets/authentication_widgets/sign_in_button.dart';

class LoginForm extends StatelessWidget {
  final AuthenticationBloc loginBloc;
  final TextEditingController _schoolIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginForm({required this.loginBloc, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _schoolIdField(),
              const SizedBox(height: 5),
              _passwordField(),
              const SizedBox(height: 40),
              SignInButton(
                onPressed: () {
                  loginBloc.add(LoginButtonClickedEvent(
                    _schoolIdController.text,
                    _passwordController.text,
                  ));
                },
              ),
            ],
          ),
          Positioned(
            right: 5,
            top: 115,
            child: GestureDetector(
              onTap: () {
                // Handle forgot password action
              },
              child: const Text(
                'Forgot Password?',
                style: TextStyle(
                  color: Colors.white60,
                  fontFamily: 'Manrope',
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _schoolIdField() {
    return SizedBox(
      width: 287,
      height: 55,
      child: TextField(
        controller: _schoolIdController,
        decoration: InputDecoration(
          hintText: 'School ID',
          filled: true,
          fillColor: Colors.white.withOpacity(0.2),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: Colors.black.withOpacity(0.1),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: Colors.black.withOpacity(0.1),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: Colors.black.withOpacity(0.1),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12.0,
          ),
        ),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12.0,
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w100,
        ),
      ),
    );
  }

  Widget _passwordField() {
    return SizedBox(
      width: 287,
      height: 55,
      child: TextField(
        controller: _passwordController,
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Password',
          filled: true,
          fillColor: Colors.white.withOpacity(0.2),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: Colors.black.withOpacity(0.1),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: Colors.black.withOpacity(0.1),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: Colors.black.withOpacity(0.1),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12.0,
          ),
        ),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12.0,
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w100,
        ),
      ),
    );
  }
}
