import 'package:flutter/material.dart';

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
                height: 170,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green,
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
                              'Active',
                              style: TextStyle(
                                fontSize: 17,
                                color: Color(0xFF6D7278),
                              ),
                            ),
                            Text(
                              '$activeCount',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Inactive',
                              style: TextStyle(
                                fontSize: 17,
                                color: Color(0xFF6D7278),
                              ),
                            ),
                            Text(
                              '$inactiveCount',
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
