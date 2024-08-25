import 'package:flutter/material.dart';
import 'package:isHKolarium/constants/colors.dart';
import 'package:isHKolarium/features/login/bloc/login_bloc.dart';

class SignInButton extends StatelessWidget {
  final LoginBloc loginBloc;
  const SignInButton({required this.loginBloc, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        loginBloc.add(LoginButtonClickedEvent());
      },
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
