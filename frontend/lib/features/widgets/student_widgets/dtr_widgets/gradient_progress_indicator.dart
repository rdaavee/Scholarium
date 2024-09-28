import 'package:flutter/material.dart';
import 'package:isHKolarium/config/constants/colors.dart';

class GradientProgressIndicator extends StatelessWidget {
  final double progress;

  const GradientProgressIndicator({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: SizedBox(
        height: 5.0,
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: [Color(0xFF549E73), Color(0xFF6DD400)],
        //     begin: Alignment.centerLeft,
        //     end: Alignment.centerRight,
        //   ),
        // ),
        child: LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[200],
          valueColor: const AlwaysStoppedAnimation<Color>(ColorPalette.primary),
        ),
      ),
    );
  }
}
