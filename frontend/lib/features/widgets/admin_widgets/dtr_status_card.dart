import 'package:flutter/material.dart';

class DtrStatusCard extends StatelessWidget {
  final String title;
  final int completedCount;
  final Color cardColor;
  final double width;
  final double height;

  const DtrStatusCard({
    super.key,
    required this.title,
    required this.completedCount,
    required this.cardColor,
    this.width = 160,
    this.height = 230,
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
                height: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                        color: Colors.purple,
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
                              'Completed',
                              style: TextStyle(
                                fontSize: 17,
                                color: Color(0xFF6D7278),
                              ),
                            ),
                            Text(
                              '$completedCount',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
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
