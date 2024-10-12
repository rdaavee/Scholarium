import 'package:flutter/material.dart';
import 'package:isHKolarium/components/onboard_data.dart';
import 'package:isHKolarium/features/widgets/onboard_widgets/onboard_body.dart';
import 'package:isHKolarium/features/widgets/onboard_widgets/onboard_button.dart';
import 'package:isHKolarium/features/widgets/onboard_widgets/onboard_dots.dart';

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
          OnboardBody(
            pageController: pageController,
            currentIndex: currentIndex,
            controller: controller,
          ),
          OnboardDots(
              currentIndex: currentIndex, totalItems: controller.items.length),
          OnboardButton(
            currentIndex: currentIndex,
            onNextPage: () {
              pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
            },
          ),
        ],
      ),
    );
  }
}
