import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isHKolarium/api/models/notifications_model.dart';
import 'package:isHKolarium/config/constants/colors.dart';

class NotificationCard extends StatelessWidget {
  final Color color;
  final NotificationsModel notifications;

  const NotificationCard(
      {super.key, required this.color, required this.notifications});

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
    return '${months[parsedDate.month - 1]}. ${parsedDate.day}, ${parsedDate.year}';
  }

  String _formatTime(String time) {
    final DateTime parsedTime = DateFormat('HH:mm:ss').parse(time);
    return DateFormat('h:mm a').format(parsedTime);
  }

  @override
  Widget build(BuildContext context) {
    final bool isUnread = notifications.status == false;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: isUnread ? const Color(0xFFECEFF1) : Color(0xFFF0F3F4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.grey,
                    backgroundImage: notifications.profilePicture != null
                        ? NetworkImage(notifications.profilePicture.toString())
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
                                notifications.senderName.toString(),
                                style: TextStyle(
                                  fontWeight: isUnread
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  _formatTime(notifications.time.toString()),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              notifications.role.toString(),
                              style: const TextStyle(
                                fontSize: 11,
                                color: ColorPalette.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (isUnread)
                              const Spacer(),
                            if (isUnread)
                              Icon(
                                Icons.circle,
                                size: 10,
                                color: Colors.blue,
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              notifications.title.toString(),
                              style: TextStyle(
                                fontSize: 12,
                                color: isUnread
                                    ? Colors.black
                                    : ColorPalette.accentBlack,
                              ),
                            ),
                            Text(
                              _formatDate(notifications.date.toString()),
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
