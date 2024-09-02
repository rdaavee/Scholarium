import 'package:flutter/material.dart';

class DtrCard extends StatelessWidget {
  final Text date;
  final Text timeIn;
  final Text timeOut;
  final Text hoursToRenderd;
  final Text hoursRenderd;
  final Text teacher;
  final Text teacherSignature;
  final Color cardColor;

  const DtrCard({
    super.key,
    required this.date,
    required this.timeIn,
    required this.timeOut,
    required this.hoursToRenderd,
    required this.hoursRenderd,
    required this.teacher,
    required this.teacherSignature,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 170,
          margin: const EdgeInsets.only(
            top: 30,
          ),
          child: Card(
            margin: const EdgeInsets.all(10.0),
            color: cardColor,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  date,
                  timeIn,
                  timeOut,
                  hoursToRenderd,
                  hoursRenderd,
                  teacher,
                  teacherSignature,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
