import 'package:flutter/material.dart';

class InfoHeader extends StatelessWidget {
  final String title;

  const InfoHeader({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 16.0),
      width: double.infinity,
      height: 51,
      decoration: BoxDecoration(
        color: Color(0x196DD400),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: Color(0xFF6DD400),
          fontSize: 15,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
