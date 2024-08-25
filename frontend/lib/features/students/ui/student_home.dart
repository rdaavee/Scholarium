import 'package:flutter/material.dart';
import 'package:isHKolarium/constants/colors.dart';
import 'package:isHKolarium/features/students/widgets/announcement_card.dart';

class StudentHome extends StatelessWidget {
  const StudentHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.accent,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Container(
              height: 100.0,
              color: ColorPalette.accent,
              alignment: Alignment.centerLeft,
              child: Text(
                "Hi, Ranier",
                style: TextStyle(
                    fontSize: 17,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height - 100.0,
              decoration: BoxDecoration(
                color: Color(0xFFF0F3F4),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: ListView(
                  children: [
                    GestureDetector(
                      child: AnnouncementCard(
                        textLabel: Text(
                          'Announcements',
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6D7278),
                              letterSpacing: 0.5),
                        ),
                        textBody: Text(
                          'Here is the body of the announcement.',
                          style: TextStyle(
                            fontFamily: 'Inter',
                          ),
                        ),
                        date: Text('Today'),
                        time: Text('Now'),
                        cardColor: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      child: AnnouncementCard(
                        textLabel: Text(
                          'Your DTR',
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6D7278),
                              letterSpacing: 0.5),
                        ),
                        textBody: Text(
                          'Here is the body of the announcement.',
                          style: TextStyle(
                            fontFamily: 'Inter',
                          ),
                        ),
                        date: Text('Today'),
                        time: Text('Now'),
                        cardColor: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      child: AnnouncementCard(
                        textLabel: Text(
                          'Events',
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6D7278),
                              letterSpacing: 0.5),
                        ),
                        textBody: Text(
                          'Here is the body of the announcement.',
                          style: TextStyle(
                            fontFamily: 'Inter',
                          ),
                        ),
                        date: Text('Today'),
                        time: Text('Now'),
                        cardColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
