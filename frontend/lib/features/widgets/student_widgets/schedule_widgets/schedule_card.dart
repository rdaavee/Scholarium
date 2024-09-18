import 'package:flutter/material.dart';

class ScheduleCard extends StatelessWidget {
  final Text scheduleDate;
  final Text scheduleTime;
  final Text roomName;
  final Color cardColor;
  final String imageUrl;

  const ScheduleCard({
    super.key,
    required this.scheduleDate,
    required this.scheduleTime,
    required this.roomName,
    required this.cardColor,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 200,
          child: Card(
            margin: const EdgeInsets.all(10.0),
            color: cardColor,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                  image: AssetImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
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
        ),
      ],
    );
  }
}
