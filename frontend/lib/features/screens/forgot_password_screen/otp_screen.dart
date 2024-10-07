// OTPScreen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:isHKolarium/features/screens/forgot_password_screen/reset_password.dart';

class OTPScreen extends StatelessWidget {
  final String email;
  final List<TextEditingController> otpControllers =
      List.generate(6, (index) => TextEditingController());

  OTPScreen({required this.email});

  @override
  Widget build(BuildContext context) {
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
              "An 6-digit code has been sent to $email",
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
                  child: TextField(
                    controller: otpControllers[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: '',
                      counterStyle: const TextStyle(
                        color: Colors.white,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                            color: ColorPalette.primary, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                    maxLength: 1,
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
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorPalette.primary,
                minimumSize: const Size(360, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                final otp =
                    otpControllers.map((controller) => controller.text).join();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ResetPasswordScreen(email: email, otp: otp),
                  ),
                );
              },
              child: const Text(
                'Verify OTP',
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
  }
}
