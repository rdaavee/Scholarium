// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isHKolarium/config/constants/colors.dart';

class NotificationCard extends StatelessWidget {
  final Color color;
  final String sender;
  final String senderName;
  final String receiver;
  final String role;
  final String title;
  final String message;
  final String status;
  final String date;
  final String time;
  final String profilePicture;

  const NotificationCard({
    super.key,
    required this.color,
    required this.sender,
    required this.senderName,
    required this.receiver,
    required this.role,
    required this.title,
    required this.message,
    required this.status,
    required this.date,
    required this.time,
    required this.profilePicture,
  });

  String _formatDate(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    final List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final String formattedDate =
        '${months[parsedDate.month - 1]}. ${parsedDate.day}, ${parsedDate.year}';
    return formattedDate;
  }

  String _formatTime(String time) {
    final DateTime parsedTime = DateFormat('HH:mm:ss').parse(time);
    return DateFormat('h:mm a').format(parsedTime);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: Color(0xFFF0F3F4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.grey,
                    backgroundImage: profilePicture != null
                        ? NetworkImage(profilePicture)
                        : null,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                senderName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Text(
                              time,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          role,
                          style: const TextStyle(
                            fontSize: 11,
                            color: ColorPalette.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 12,
                                color: ColorPalette.accentBlack,
                              ),
                            ),
                            Text(
                              date,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
