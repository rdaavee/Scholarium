// ResetPasswordScreen.dart
import 'package:flutter/material.dart';
import 'package:isHKolarium/config/constants/colors.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String email;
  final String otp;
  final TextEditingController currentPassController = TextEditingController();
  final TextEditingController newPassController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  ResetPasswordScreen({required this.email, required this.otp});

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
              controller: currentPassController,
              decoration: InputDecoration(
                labelText: 'Current password',
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
                  borderSide:
                      const BorderSide(color: ColorPalette.primary, width: 2),
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
                  borderSide:
                      const BorderSide(color: ColorPalette.primary, width: 2),
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
                  borderSide:
                      const BorderSide(color: ColorPalette.primary, width: 2),
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
              onPressed: () {},
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
  }
}
