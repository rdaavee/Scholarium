import 'package:flutter/material.dart';
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
        backgroundColor: Color(0xFF3B4F26),
        side: BorderSide(
          color: Color(0xFF3B4F26),
        ),
        minimumSize: Size(250, 55),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
      child: Text(
        'Sign In',
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}
