import 'package:flutter/material.dart';

class GradientProgressIndicator extends StatelessWidget {
  final double progress;

  const GradientProgressIndicator({
    Key? key,
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        height: 5.0,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF549E73), Color(0xFF6DD400)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.transparent,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.transparent),
        ),
      ),
    );
  }
}
