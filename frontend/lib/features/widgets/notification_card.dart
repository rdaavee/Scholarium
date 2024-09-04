import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final String sender;
  final String role;
  final String message;
  final String status;
  final String date;
  final String time;

  NotificationCard({
    required this.sender,
    required this.role,
    required this.message,
    required this.status,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    if (status == 'unread') {
      return Column(
        children: [
          const SizedBox(height: 10),
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
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(
                              thickness: .1,
                              color: Colors.black,
                            ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              sender,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inter',
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 16),
                            child: Text(
                              date,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Inter',
                                fontSize: 11,
                              ),
                            ),
                          ),
                          Text(
                            time,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontFamily: 'Inter',
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(width: 22),
                        ],
                      ),
                      Text(
                        role,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Inter',
                        ),
                      ),
                      Text(
                        message,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFC1C1C1),
                          fontFamily: 'Inter',
                        ),
                      ),
                      const Divider(
                              thickness: .1,
                              color: Colors.black,
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          color: Colors.grey[300],
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  radius: 25,
                  child: const Icon(Icons.person, color: Colors.white),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(
                            thickness: .1,
                            color: Colors.black,
                          ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            sender,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 16),
                          child: Text(
                            date,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontFamily: 'Inter',
                              fontSize: 11,
                            ),
                          ),
                        ),
                        Text(
                          time,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Inter',
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(width: 22),
                      ],
                    ),
                    Text(
                      role,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                      ),
                    ),
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFC1C1C1),
                        fontFamily: 'Inter',
                      ),
                    ),
                    const Divider(
                            thickness: .1,
                            color: Colors.black,
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
}
