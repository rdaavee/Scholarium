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
      width: 300.0, // Set a fixed width for uniformity
      child: Card(
        margin: const EdgeInsets.all(10.0),
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
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
            ),
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              ),
              child: Image.asset(
                imageUrl,
                fit: BoxFit.cover,
                height: 150.0, // Match card height
                width: 80.0, // Adjust width for a good fit
              ),
            ),
          ],
        ),
      ),
    );
  }
}
