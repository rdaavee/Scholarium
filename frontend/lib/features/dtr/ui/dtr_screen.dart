import 'package:flutter/material.dart';
import 'package:isHKolarium/constants/colors.dart';

class DtrScreen extends StatelessWidget {
  const DtrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.primary,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 30.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back_rounded),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  height: 100.0,
                  color: ColorPalette.primary,
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Your DTR",
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF0F3F4),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
