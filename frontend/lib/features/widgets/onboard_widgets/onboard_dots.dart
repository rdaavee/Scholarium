import 'package:flutter/material.dart';
import 'package:isHKolarium/config/constants/colors.dart';

class OnboardDots extends StatelessWidget {
  final int currentIndex;
  final int totalItems;

  const OnboardDots({
    super.key,
    required this.currentIndex,
    required this.totalItems,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalItems,
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
}
