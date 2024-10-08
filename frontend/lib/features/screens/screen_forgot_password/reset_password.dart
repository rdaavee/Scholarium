// ResetPasswordScreen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/blocs/bloc_authentication/authentication_bloc.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:isHKolarium/features/screens/screen_login/login_page.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;

  ResetPasswordScreen({super.key, required this.email, required this.otp});

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
      listener: (context, state) {
        if (state is ResetPasswordNavigateToLoginPageActionState) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
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
                      fontFamily: 'Manrope',
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
                    fontFamily: 'Manrope',
                    fontSize: 11,
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: newPassController,
                  decoration: InputDecoration(
                    labelText: 'New password',
                    labelStyle: const TextStyle(
                      color: Colors.grey,
                      fontFamily: 'Manrope',
                      fontSize: 13,
                    ),
                    floatingLabelStyle: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: ColorPalette.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(
                          color: ColorPalette.primary, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    hoverColor: ColorPalette.primary,
                  ),
                  obscureText: true,
                ),
                const SizedBox(
                  height: 13,
                ),
                TextField(
                  controller: confirmPassController,
                  decoration: InputDecoration(
                    labelText: 'Confirm new password',
                    labelStyle: const TextStyle(
                      color: Colors.grey,
                      fontFamily: 'Manrope',
                      fontSize: 13,
                    ),
                    floatingLabelStyle: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: ColorPalette.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(
                          color: ColorPalette.primary, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    hoverColor: ColorPalette.primary,
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorPalette.primary,
                    minimumSize: const Size(360, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
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
                        ResetPasswordEvent(
                            widget.email, widget.otp, confirmPassword),
                      );
                    }
                  },
                  child: const Text(
                    'Reset Password',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 11.5,
                      color: ColorPalette.accentWhite,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
