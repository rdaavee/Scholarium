import 'package:flutter/material.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:isHKolarium/features/widgets/notification_card.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.primary,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Container(
              height: 100.0,
              color: ColorPalette.primary,
              alignment: Alignment.centerLeft,
              child: Text(
                "Notification",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFF0F3F4),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: ListView(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Divider(
                    thickness: .1,
                    color: Colors.black,
                  ),
                  NotificationCard(
                    name: "Regine Lopez",
                    role: "Professor",
                    message:
                        "Make sure to fill up this bar so you can renew your scholar. Work hard Flames!",
                    time: "12:14 PM",
                  ),
                  Divider(
                    thickness: .1,
                    color: Colors.black,
                  ),
                  NotificationCard(
                    name: "Regine Lopez",
                    role: "Professor",
                    message:
                        "Make sure to fill up this bar so you can renew your scholar. Work hard Flames!",
                    time: "12:14 PM",
                  ),
                  Divider(
                    thickness: .1,
                    color: Colors.black,
                  ),
                  NotificationCard(
                    name: "Regine Lopez",
                    role: "Professor",
                    message:
                        "Make sure to fill up this bar so you can renew your scholar. Work hard Flames!",
                    time: "12:14 PM",
                  ),
                  Divider(
                    thickness: .1,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
