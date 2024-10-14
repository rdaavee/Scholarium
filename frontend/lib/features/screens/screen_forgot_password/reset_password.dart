// ResetPasswordScreen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/blocs/bloc_authentication/authentication_bloc.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:isHKolarium/features/screens/screen_login/login_page.dart';
import 'package:isHKolarium/features/widgets/forgot_password_widgets/custom_passwordfield.dart';
import 'package:isHKolarium/features/widgets/forgot_password_widgets/custom_resetbutton.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController newPassController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();
  late final AuthenticationBloc authenticationBloc;

  @override
  void initState() {
    super.initState();
    authenticationBloc = AuthenticationBloc(GlobalRepositoryImpl());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      bloc: authenticationBloc,
      listener: (context, state) {
        if (state is ResetPasswordNavigateToLoginPageActionState) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        } else if (State is PasswordErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Confirm Password and New Password is not the same'),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: ColorPalette.accentBlack,
                size: 13.0,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/enter-password-img.png',
                  width: 230,
                  height: 230,
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'Create new password',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: ColorPalette.accentBlack),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  'Set your new password so you can login and access isHKolarium',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomPasswordField(
                  controller: newPassController,
                  labelText: 'New password',
                  borderColor: Colors.grey,
                  focusedBorderColor: ColorPalette.primary,
                  hoverColor: ColorPalette.primary,
                ),
                const SizedBox(
                  height: 13,
                ),
                CustomPasswordField(
                  controller: confirmPassController,
                  labelText: 'Confirm new password',
                  borderColor: Colors.grey,
                  focusedBorderColor: ColorPalette.primary,
                  hoverColor: ColorPalette.primary,
                ),
                const SizedBox(height: 20),
                CustomResetButton(
                  buttonText: 'Reset Password',
                  backgroundColor: ColorPalette.primary,
                  textColor: ColorPalette.accentWhite,
                  onPressed: () async {
                    String newPassword = newPassController.text.trim();
                    String confirmPassword = confirmPassController.text.trim();

                    if (newPassword.isEmpty || confirmPassword.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill in both password fields'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else if (newPassword != confirmPassword) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Passwords do not match'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      authenticationBloc.add(
                        ResetPasswordEvent(widget.email, confirmPassword),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
