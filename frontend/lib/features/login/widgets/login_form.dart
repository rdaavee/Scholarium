import 'package:flutter/material.dart';
import 'package:isHKolarium/features/login/bloc/login_bloc.dart';
import 'package:isHKolarium/features/login/widgets/sign_in_button.dart';

class LoginForm extends StatelessWidget {
  final LoginBloc loginBloc;
  const LoginForm({required this.loginBloc, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _schoolIdField(),
                  SizedBox(height: 5),
                  _passwordField(),
                  SizedBox(height: 35),
                  SignInButton(loginBloc: loginBloc),
                ],
              ),
              Positioned(
                right: 5,
                top: 110,
                child: GestureDetector(
                  onTap: () {
                    // Handle forgot password action
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Color(0xFF6D7278),
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _schoolIdField() {
    return Container(
      width: 287,
      height: 55,
      child: TextField(
        decoration: InputDecoration(
          hintText: 'School ID',
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
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
            color: Colors.grey,
            fontSize: 12.0,
          ),
        ),
        style: TextStyle(
          color: Colors.black,
          fontSize: 12.0,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w100,
        ),
      ),
    );
  }

  Widget _passwordField() {
    return Container(
      width: 287,
      height: 55,
      child: TextField(
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Password',
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
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
            color: Colors.grey,
            fontSize: 12.0,
          ),
        ),
        style: TextStyle(
          color: Colors.black,
          fontSize: 12.0,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w100,
        ),
      ),
    );
  }
}
