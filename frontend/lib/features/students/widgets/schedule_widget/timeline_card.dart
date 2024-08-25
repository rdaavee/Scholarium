import 'package:flutter/material.dart';

class TimelineCard extends StatelessWidget {
  final String dutyTitle;
  final String professorName;
  final String roomName;
  final String timeInAndOut;
  final bool isCompleted;
  final Color cardColor;

  TimelineCard({
    required this.dutyTitle,
    required this.professorName,
    required this.roomName,
    required this.timeInAndOut,
    required this.isCompleted,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color completedCardColor = Colors.grey[200] ?? Colors.grey.shade200;
    final Color completedTextColor = Colors.grey[600] ?? Colors.grey.shade600;
    final Color completedDetailTextColor =
        Colors.grey[400] ?? Colors.grey.shade400;

    return SizedBox(
      width: 250,
      height: 170,
      child: Card(
        margin: const EdgeInsets.all(20),
        elevation: 4.0,
        color: isCompleted ? completedCardColor : cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dutyTitle,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isCompleted ? completedTextColor : Color(0xFF6D7278),
                ),
              ),
              Text(
                professorName,
                style: TextStyle(
                  color: isCompleted
                      ? completedDetailTextColor
                      : Color(0xFFC1C1C1),
                ),
              ),
              SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    roomName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:
                          isCompleted ? completedTextColor : Color(0xFF6D7278),
                    ),
                  ),
                  Text(
                    timeInAndOut,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isCompleted
                          ? completedDetailTextColor
                          : Color(0xFF6D7278),
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
