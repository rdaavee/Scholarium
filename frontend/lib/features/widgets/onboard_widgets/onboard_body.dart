import 'package:flutter/material.dart';
import 'package:isHKolarium/components/onboard_data.dart';
import 'package:isHKolarium/config/constants/colors.dart';

class OnboardBody extends StatelessWidget {
  final PageController pageController;
  final int currentIndex;
  final OnboardData controller;
  final Function(int) onPageChanged;

  const OnboardBody({
    super.key,
    required this.pageController,
    required this.currentIndex,
    required this.controller,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PageView.builder(
        controller: pageController,
        itemCount: controller.items.length,
        onPageChanged: onPageChanged,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(controller.items[index].image),
                const SizedBox(height: 20),
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
                const SizedBox(height: 5),
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
}
