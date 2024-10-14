import 'package:flutter/material.dart';

class NoData extends StatelessWidget {
  final String title;

  const NoData({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            width: 480,
            decoration: const BoxDecoration(
              color: Color(0xFFF0F3F4),
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/no-data-img.png',
                  height: 230,
                  width: 230,
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
