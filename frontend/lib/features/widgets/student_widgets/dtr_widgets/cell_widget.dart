import 'package:flutter/material.dart';

class CellWidget extends StatelessWidget {
  final String text;

  const CellWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 8.7,
          ),
        ),
      ),
    );
  }
}
