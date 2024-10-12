// OTPScreen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/blocs/bloc_authentication/authentication_bloc.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:isHKolarium/features/screens/screen_forgot_password/reset_password.dart';
import 'package:isHKolarium/features/widgets/forgot_password_widgets/custom_otp_textfield.dart';
import 'package:isHKolarium/features/widgets/forgot_password_widgets/custom_verifybutton.dart';

class OTPScreen extends StatefulWidget {
  final String email;

  const OTPScreen({super.key, required this.email});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final List<TextEditingController> otpControllers =
      List.generate(6, (index) => TextEditingController());
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
        if (state is OTPNavigateToResetPageActionState) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ResetPasswordScreen(email: widget.email)),
          );
        } else if (State is PasswordLoadingState) {
          Center(child: CircularProgressIndicator());
        } else if (State is PasswordErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid or Expired Code!')),
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
                  'assets/images/enter-otp-img.png',
                  width: 230,
                  height: 230,
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'Enter OTP',
                  style: TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: ColorPalette.accentBlack),
                ),
                Text(
                  "An 6-digit code has been sent to ${widget.email}",
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 11,
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 40,
                      child: CustomOTPTextField(
                        controller: otpControllers[index],
                        index: index,
                        onChanged: (value) {
                          if (value.length == 1 && index < 5) {
                            FocusScope.of(context).nextFocus();
                          } else if (value.isEmpty && index > 0) {
                            FocusScope.of(context).previousFocus();
                          }
                        },
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),
                CustomVerifyButton(
                  buttonText: 'Verify OTP',
                  backgroundColor: ColorPalette.primary,
                  textColor: ColorPalette.accentWhite,
                  onPressed: () {
                    authenticationBloc.add(
                      VerifyCode(
                        widget.email,
                        otpControllers
                            .map((controller) => controller.text)
                            .join(),
                      ),
                    );
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
