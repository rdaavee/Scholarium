import 'package:flutter/material.dart';
import 'package:isHKolarium/features/widgets/student_widgets/dtr_widgets/gradient_progress_indicator.dart';

class YourDtrHoursCard extends StatelessWidget {
  final double progress;
  final Color cardColor;

  const YourDtrHoursCard({
    super.key,
    required this.progress,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: Card(
        margin: const EdgeInsets.all(10.0),
        color: cardColor,
        shape: const RoundedRectangleBorder(
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
                  fontFamily: 'Manrope',
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
                  fontFamily: 'Manrope',
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
