import 'package:flutter/material.dart';

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
    this.width = 160,
    this.height = 220,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: <Widget>[
          Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5,
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 5,
                  child: Container(
                    color: cardColor,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Positioned(
              bottom: 0,
              left: 10,
              child: SizedBox(
                height: 240,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Manrope',
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(height: 35),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              '25%',
                              style: TextStyle(
                                fontSize: 17,
                                fontFamily: 'Manrope',
                                color: Color(0xFF6D7278),
                              ),
                            ),
                            Text(
                              '$discount25',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Manrope',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              '50%',
                              style: TextStyle(
                                fontSize: 17,
                                fontFamily: 'Manrope',
                                color: Color(0xFF6D7278),
                              ),
                            ),
                            Text(
                              '$discount50',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Manrope',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              '75%',
                              style: TextStyle(
                                fontSize: 17,
                                fontFamily: 'Manrope',
                                color: Color(0xFF6D7278),
                              ),
                            ),
                            Text(
                              '$discount75',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Manrope',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
