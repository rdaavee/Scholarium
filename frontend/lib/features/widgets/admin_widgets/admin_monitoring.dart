import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isHKolarium/config/constants/colors.dart';

class AdminMonitoring extends StatefulWidget {
  final int announcementCount;
  final int dtrCompletedCount;
  const AdminMonitoring(
      {super.key,
      required this.announcementCount,
      required this.dtrCompletedCount});

  @override
  State<AdminMonitoring> createState() => _AdminMonitoringState();
}

class _AdminMonitoringState extends State<AdminMonitoring> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            announcementContainer(
              context,
              CupertinoIcons.bell_circle_fill,
              "Announcements",
              widget.announcementCount,
              ColorPalette.primary,
              Colors.white,
            ),
            announcementContainer(
              context,
              CupertinoIcons.checkmark_alt_circle_fill,
              "DTR Completed",
              widget.dtrCompletedCount,
              ColorPalette.primary,
              Colors.white,
            ),
          ],
        ),
      ],
    );
  }

  Widget announcementContainer(BuildContext context, IconData icon, String text,
      int announcementCreated, Color color, Color textColor) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        height: 80,
        width: 160,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  icon,
                  color: textColor,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    "$announcementCreated",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
