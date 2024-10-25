import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:diagonal_decoration/diagonal_decoration.dart';

class HkDiscountStatusCard extends StatelessWidget {
  final String title;
  final int discount25;
  final int discount50;
  final int discount75;
  final Color cardColor;
  final double width;
  final double height;

  const HkDiscountStatusCard({
    super.key,
    required this.title,
    required this.discount25,
    required this.discount50,
    required this.discount75,
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
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('25%',
                          style: TextStyle(
                              fontSize: 17, color: Color(0xFF6D7278))),
                      Text('$discount25',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('50%',
                          style: TextStyle(
                              fontSize: 17, color: Color(0xFF6D7278))),
                      Text('$discount50',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('75%',
                          style: TextStyle(
                              fontSize: 17, color: Color(0xFF6D7278))),
                      Text('$discount75',
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
