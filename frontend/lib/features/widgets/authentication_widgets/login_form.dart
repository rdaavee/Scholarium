import 'package:flutter/material.dart';
import 'package:isHKolarium/blocs/bloc_authentication/authentication_bloc.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:isHKolarium/features/screens/screen_forgot_password/email_screen.dart';
import 'package:isHKolarium/features/widgets/authentication_widgets/login_password_textfield.dart';
import 'package:isHKolarium/features/widgets/authentication_widgets/school_id_textfield.dart';
import 'package:isHKolarium/features/widgets/authentication_widgets/sign_in_button.dart';

class LoginForm extends StatelessWidget {
  final AuthenticationBloc loginBloc;
  final TextEditingController _schoolIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginForm({required this.loginBloc, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SchoolIdField(controller: _schoolIdController),
            const SizedBox(height: 5),
            PasswordField(
              schoolIdController: _schoolIdController,
              passwordController: _passwordController,
              loginBloc: loginBloc,
            ),
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EmailScreen()));
            },
            child: const Text(
              'Forgot Password?',
              style: TextStyle(
                color: ColorPalette.primary,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
