import 'package:flutter/material.dart';
import 'package:isHKolarium/components/onboard_data.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:isHKolarium/features/screens/screen_login/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardScreen extends StatefulWidget {
  static const String routeName = 'OnboardScreen';

  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  final controller = OnboardData();
  final pageController = PageController();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          body(),
          buildDots(),
          buildBtn(),
        ],
      ),
    );
  }

  // body
  Widget body() {
    return Expanded(
      child: PageView.builder(
        controller: pageController,
        itemCount: controller.items.length,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(controller.items[index].image),
                SizedBox(height: 20),
                Text(
                  controller.items[index].title,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Manrope',
                    color: ColorPalette.btnColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 5),
                Text(
                  controller.items[index].description,
                  style: const TextStyle(
                    fontSize: 13,
                    fontFamily: 'Manrope',
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // pagination
  Widget buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        controller.items.length,
        (index) => AnimatedContainer(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: currentIndex == index ? ColorPalette.btnColor : Colors.grey,
          ),
          height: 7,
          width: currentIndex == index ? 30 : 7,
          duration: const Duration(milliseconds: 700),
        ),
      ),
    );
  }

  Widget buildBtn() {
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
          if (currentIndex == controller.items.length - 1) {
            // Save completion status to SharedPreferences
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setBool('hasCompletedOnboarding', true);

            // Navigate to the login page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
          } else {
            pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          }
        },
        child: Text(
          currentIndex == controller.items.length - 1
              ? "Get Started"
              : "Continue",
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
