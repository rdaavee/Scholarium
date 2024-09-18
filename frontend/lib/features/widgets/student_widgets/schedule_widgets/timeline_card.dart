import 'package:flutter/material.dart';

class TimelineCard extends StatelessWidget {
  final String dutyTitle;
  final String professorName;
  final String roomName;
  final String timeInAndOut;
  final bool isCompleted;
  final bool isNotCompleted;
  final Color cardColor;

  const TimelineCard({
    super.key,
    required this.dutyTitle,
    required this.professorName,
    required this.roomName,
    required this.timeInAndOut,
    required this.isCompleted,
    required this.isNotCompleted,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color completedCardColor = Colors.grey[300] ?? Colors.grey.shade300;

    final Color notCompletedCardColor =
        Colors.grey[300] ?? Colors.grey.shade200;

    final Color completedTextColor = Colors.grey[600] ?? Colors.grey.shade600;

    final Color completedDetailTextColor =
        Colors.grey[400] ?? Colors.grey.shade400;

    final Color currentCardColor = isCompleted
        ? completedCardColor
        : (isNotCompleted ? notCompletedCardColor : cardColor);

    final Color currentTextColor = isCompleted
        ? completedTextColor
        : Colors.grey[600] ?? Colors.grey.shade600;

    final Color currentDetailTextColor = isCompleted
        ? completedDetailTextColor
        : Colors.grey[400] ?? Colors.grey.shade400;

    return SizedBox(
      width: double.infinity,
      child: Card(
        margin: const EdgeInsets.all(10.0),
        elevation: 4.0,
        color: currentCardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dutyTitle,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: currentTextColor,
                ),
              ),
              Text(
                professorName,
                style: TextStyle(
                  color: currentDetailTextColor,
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    roomName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: currentTextColor,
                    ),
                  ),
                  Text(
                    timeInAndOut,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: currentDetailTextColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
