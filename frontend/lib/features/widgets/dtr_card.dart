import 'package:flutter/material.dart';
import 'package:isHKolarium/features/widgets/gradient_progress_indicator.dart';

class DTRCard extends StatelessWidget {
  final double progress;
  final Color cardColor;

  const DTRCard({
    Key? key,
    required this.progress,
    required this.cardColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: Card(
        margin: const EdgeInsets.all(10.0),
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Make sure to fill up this bar so you can renew your scholar.\nWork hard Flames!',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.normal,
                  color: Color(0xFFC1C1C1),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Progress',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6D7278),
                ),
              ),
              const SizedBox(height: 5),
              GradientProgressIndicator(
                progress: progress,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
