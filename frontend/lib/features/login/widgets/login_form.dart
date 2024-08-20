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
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10.0,
              spreadRadius: 2.0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _schoolIdField(),
              SizedBox(height: 15),
              _passwordField(),
              SizedBox(height: 15),
              SignInButton(loginBloc: loginBloc),
            ],
          ),
        ),
      ),
    );
  }

  Widget _schoolIdField() {
    return TextField(
      decoration: InputDecoration(labelText: 'Email'),
    );
  }

  Widget _passwordField() {
    return TextField(
      decoration: InputDecoration(labelText: 'Password'),
      obscureText: true,
    );
  }
}
