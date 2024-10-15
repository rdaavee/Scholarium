import 'package:flutter/material.dart';
import 'package:isHKolarium/blocs/bloc_authentication/authentication_bloc.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:isHKolarium/features/widgets/authentication_widgets/login_form.dart';

class LoginFormWidget extends StatelessWidget {
  final AuthenticationBloc loginBloc;

  const LoginFormWidget({Key? key, required this.loginBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 40,
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 60),
          child: RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: 'is',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: ColorPalette.accentBlack,
                    letterSpacing: 5,
                  ),
                ),
                TextSpan(
                  text: 'HK',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ColorPalette.primary,
                    letterSpacing: 5,
                  ),
                ),
                TextSpan(
                  text: 'olarium',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: ColorPalette.accentBlack,
                    letterSpacing: 5,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Login your account',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ColorPalette.accentBlack,
                    ),
                  ),
                  const SizedBox(height: 30),
                  LoginForm(loginBloc: loginBloc),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
