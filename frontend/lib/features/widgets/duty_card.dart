import 'package:flutter/material.dart';

class DutyCard extends StatelessWidget {
  final Color cardColor;
  final String time;
  final String roomName;

  const DutyCard({
    required this.cardColor,
    required this.time,
    required this.roomName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Facilitator Duty',
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                  letterSpacing: 1.1,
                  color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              time,
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 5),
            Text(
              roomName,
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'People',
              style: TextStyle(
                fontSize: 11,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 5),
            Row(
              children: [
                CircleAvatar(backgroundColor: Colors.white),
                SizedBox(width: 5),
                CircleAvatar(backgroundColor: Colors.grey[300]),
                SizedBox(width: 5),
                CircleAvatar(backgroundColor: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
