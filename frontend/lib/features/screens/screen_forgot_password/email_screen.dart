// EmailScreen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/blocs/bloc_authentication/authentication_bloc.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:isHKolarium/features/screens/screen_forgot_password/otp_screen.dart';

class EmailScreen extends StatefulWidget {
  const EmailScreen({super.key});

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final TextEditingController emailController = TextEditingController();
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
        if (state is EmailNavigateToOTPPageActionState) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OTPScreen(email: emailController.text)),
          );
        } else if (state is PasswordLoadingState) {
            Center(child: CircularProgressIndicator());
        } else if (State is PasswordErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid Credential')),
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
                  'assets/images/enter-email-img.png',
                  width: 230,
                  height: 230,
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'Forgot Password?',
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
                  'Enter the email address associated with your account',
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
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
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
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'Manrope',
                    fontSize: 13,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorPalette.primary,
                    minimumSize: const Size(360, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                  ),
                  onPressed: () async {
                    authenticationBloc.add(
                      GetOTPEvent(emailController.text),
                    );
                  },
                  child: const Text(
                    'Next',
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
