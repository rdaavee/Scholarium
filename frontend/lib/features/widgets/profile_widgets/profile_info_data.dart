import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({required this.label, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF3C3C3C),
            fontSize: 16.5,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFFC1C1C1),
            fontSize: 16.5,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
