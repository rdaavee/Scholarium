import 'package:flutter/material.dart';
import 'package:isHKolarium/constants/colors.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.accent, // Custom accent color from constants
      body: Column(
        children: [
          // App bar style header for Notifications
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Container(
              height: 100.0,
              color: ColorPalette.accent,
              alignment: Alignment.centerLeft,
              child: Text(
                "Notification",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
            ),
          ),
          // Main content area with rounded top corners
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFF0F3F4), // Light grey background for content
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: ListView(
                children: [
                  // First notification item
                  NotificationItem(
                    name: "Regine Lopez",
                    role: "Professor",
                    message:
                        "Make sure to fill up this bar so you can renew your scholar. Work hard Flames!",
                    time: "12:14 PM",
                  ),
                  // Second notification item
                  NotificationItem(
                    name: "Regine Lopez",
                    role: "Professor",
                    message:
                        "Make sure to fill up this bar so you can renew your scholar. Work hard Flames!",
                    time: "12:14 PM",
                  ),
                  // Third notification item
                  NotificationItem(
                    name: "Regine Lopez",
                    role: "Professor",
                    message:
                        "Make sure to fill up this bar so you can renew your scholar. Work hard Flames!",
                    time: "12:14 PM",
                  ),
                  // Add more NotificationItem widgets if needed
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom widget for each notification item
class NotificationItem extends StatelessWidget {
  final String name;
  final String role;
  final String message;
  final String time;

  NotificationItem({
    required this.name,
    required this.role,
    required this.message,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey[300],
            radius: 25,
            child: Icon(Icons.person, color: Colors.white), // Placeholder for profile picture
          ),
          title: Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                role,
                style: TextStyle(
                  color: Colors.green, // Green color to match the design
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Montserrat',
                ),
              ),
              SizedBox(height: 4),
              Text(
                message,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontFamily: 'Montserrat',
                ),
              ),
            ],
          ),
          trailing: Text(
            time,
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
