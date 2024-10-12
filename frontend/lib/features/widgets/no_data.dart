import 'package:flutter/material.dart';

class NoData extends StatelessWidget {
  const NoData({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/no-data-img.png',
          height: 230,
          width: 230,
        ),
        const Text(
          'No notifications available',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
