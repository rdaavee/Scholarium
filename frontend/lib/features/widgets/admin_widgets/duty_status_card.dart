import 'package:flutter/material.dart';
import 'package:diagonal_decoration/diagonal_decoration.dart';

class DutyStatusCard extends StatelessWidget {
  final String title;
  final int ongoingCount;
  final int completedCount;
  final Color cardColor;
  final double width;
  final double height;

  const DutyStatusCard({
    super.key,
    required this.title,
    required this.ongoingCount,
    required this.completedCount,
    required this.cardColor,
    this.width = 260,
    this.height = 235,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: MatrixDecoration(
          lineColor: Colors.white,
          backgroundColor: Color(0xFFEBEBEB),
          radius: Radius.circular(10),
          lineWidth: 1,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 5,
              child: Container(
                color: cardColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Ongoing',
                          style: TextStyle(
                              fontSize: 17, color: Color(0xFF6D7278))),
                      Text('$ongoingCount',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Completed',
                          style: TextStyle(
                              fontSize: 17, color: Color(0xFF6D7278))),
                      Text('$completedCount',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
