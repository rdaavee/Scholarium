import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/blocs/bloc_authentication/authentication_bloc.dart';
import 'package:isHKolarium/config/constants/colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late final AuthenticationBloc authenticationBloc;
  Timer? _timer;
  bool isButtonEnabled = true;
  int remainingTime = 60;
  String otpButtonText = "Get OTP";

  @override
  void initState() {
    super.initState();
    authenticationBloc = AuthenticationBloc(GlobalRepositoryImpl());
  }

  @override
  void dispose() {
    authenticationBloc.close();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      otpButtonText = 'Resend OTP in $remainingTime';
      isButtonEnabled = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        remainingTime -= 1;
        otpButtonText = 'Resend OTP in $remainingTime';
      });

      if (remainingTime == 0) {
        timer.cancel();
        setState(() {
          otpButtonText = "Get OTP";
          remainingTime = 60;
          isButtonEnabled = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController codeController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();

    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      bloc: authenticationBloc,
      listener: (context, state) {
        if (state is PasswordLoadedSuccessState) {
          _showSnackBar(
            context,
            'Success',
            'Password updated successfully',
            ContentType.success,
          );
          Navigator.of(context).pop();
        } else if (state is PasswordErrorState) {
          _showSnackBar(
            context,
            'Error',
            state.message,
            ContentType.failure,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ColorPalette.primary,
            title: const Text(
              'Forgot Password',
              style: TextStyle(
                fontFamily: 'Manrope',
                color: ColorPalette.accentWhite,
                letterSpacing: 0.5,
                fontSize: 15,
              ),
            ),
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: ColorPalette.accentWhite,
                size: 13.0,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          backgroundColor: const Color(0xFFF0F3F4),
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/change-pass-img.png',
                      width: 250,
                      height: 250,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            emailController,
                            'Please enter your email',
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: isButtonEnabled
                              ? () {
                                  setState(() {
                                    isButtonEnabled = false;
                                  });
                                  authenticationBloc.add(
                                    GetOTPEvent(emailController.text),
                                  );
                                  _startTimer();
                                }
                              : null,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            decoration: BoxDecoration(
                              color: isButtonEnabled
                                  ? ColorPalette.btnColor
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              otpButtonText,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontFamily: 'Manrope',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      codeController,
                      'Please enter the code',
                      isConfirm: true,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      newPasswordController,
                      'Please enter your new password',
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorPalette.btnColor,
                        minimumSize: const Size(287, 55),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                      ),
                      child: const Text(
                        'Change Password',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          authenticationBloc.add(
                            ResetPasswordEvent(
                              emailController.text,
                              codeController.text,
                              newPasswordController.text,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    bool isConfirm = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isConfirm || hint.contains('password'),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 12.0),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        border: OutlineInputBorder(
          borderSide:
              BorderSide(width: 1, color: Colors.black.withOpacity(0.1)),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(width: 1, color: Colors.black.withOpacity(0.1)),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(width: 1, color: Colors.black.withOpacity(0.1)),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: const TextStyle(
        color: Colors.black,
        fontSize: 12.0,
        fontFamily: 'Manrope',
        fontWeight: FontWeight.w100,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return isConfirm
              ? 'Please confirm your new password'
              : 'Please enter your ${hint.toLowerCase()}';
        }
        return null;
      },
    );
  }

  void _showSnackBar(
    BuildContext context,
    String title,
    String message,
    ContentType contentType,
  ) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: contentType,
      ),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
