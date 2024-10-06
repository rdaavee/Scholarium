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
    return SizedBox(
      height: 150.0, // Consistent height for the card
      width: 330.0, // Set a fixed width for uniformity
      child: Card(
        margin: const EdgeInsets.all(10.0),
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Stack(
          children: [
            // Background image
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                  height: 170.0, // Match the height of the card
                  width: 90.0,
                ),
              ),
            ),
            // Foreground content
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        scheduleDate,
                        const SizedBox(height: 8),
                        scheduleTime,
                        const SizedBox(height: 8),
                        roomName,
                      ],
                    ),
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
