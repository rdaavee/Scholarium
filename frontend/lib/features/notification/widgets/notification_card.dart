import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final String name;
  final String role;
  final String message;
  final String time;

  NotificationCard({
    required this.name,
    required this.role,
    required this.message,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  radius: 25,
                  child: Icon(Icons.person, color: Colors.white),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Text(
                          time,
                          style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Inter',
                            fontSize: 11,
                          ),
                        ),
                        SizedBox(width: 22),
                      ],
                    ),
                    Text(
                      role,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                      ),
                    ),
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFC1C1C1),
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
