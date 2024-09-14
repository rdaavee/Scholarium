import 'package:flutter/material.dart';

class ScheduleCard extends StatelessWidget {
  final Text scheduleDate;
  final Text scheduleTime;
  final Text roomName;
  final Color cardColor;

  const ScheduleCard({
    super.key,
    required this.scheduleDate,
    required this.scheduleTime,
    required this.roomName,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 220,
          margin: const EdgeInsets.only(
            top: 10,
          ),
          child: Card(
            margin: const EdgeInsets.all(10.0),
            color: cardColor,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  scheduleDate,
                  const SizedBox(height: 5),
                  scheduleTime,
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [roomName],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
