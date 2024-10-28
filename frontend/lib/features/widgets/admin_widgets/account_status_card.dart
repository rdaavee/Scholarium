import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:diagonal_decoration/diagonal_decoration.dart';
import 'package:isHKolarium/config/constants/colors.dart';

class AccountStatusCard extends StatelessWidget {
  final String title;
  final int activeCount;
  final int inactiveCount;
  final Color cardColor;
  final double width;
  final double height;

  const AccountStatusCard({
    super.key,
    required this.title,
    required this.activeCount,
    required this.inactiveCount,
    required this.cardColor,
    this.width = 180,
    this.height = 230,
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
            Container(
              width: double.infinity,
              height: 5,
              color: cardColor,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: ColorPalette.primary,
                        ),
                      ),
                      // Icon(
                      //   CupertinoIcons.person_alt_circle_fill,
                      //   color: ColorPalette.primary,
                      // ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Active',
                        style: TextStyle(
                          fontSize: 17,
                          color: Color(0xFF6D7278),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '$activeCount',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Inactive',
                        style: TextStyle(
                          fontSize: 17,
                          color: Color(0xFF6D7278),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '$inactiveCount',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
