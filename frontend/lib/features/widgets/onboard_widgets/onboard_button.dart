import 'package:flutter/material.dart';
import 'package:isHKolarium/features/screens/screen_login/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:isHKolarium/config/constants/colors.dart';

class OnboardButton extends StatelessWidget {
  final int currentIndex;
  final Function onNextPage;

  const OnboardButton({
    super.key,
    required this.currentIndex,
    required this.onNextPage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 30),
      width: MediaQuery.of(context).size.width * .9,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: ColorPalette.btnColor,
      ),
      child: TextButton(
        onPressed: () async {
          if (currentIndex == 2) {
            // Adjust based on your items count
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setBool('hasCompletedOnboarding', true);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
          } else {
            onNextPage();
          }
        },
        child: Text(
          currentIndex == 2 ? "Get Started" : "Continue",
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
