import 'package:flutter/material.dart';

class AnnouncementCard extends StatelessWidget {
  final Text textLabel;
  final Text textBody;
  final Text date;
  final Text time;
  final Color cardColor;

  const AnnouncementCard({
    Key? key,
    required this.textLabel,
    required this.textBody,
    required this.date,
    required this.time,
    required this.cardColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: 25,
          left: 12,
          right: 16,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: textLabel,
          ),
        ),
        Container(
          height: 180,
          margin: EdgeInsets.only(
            top: 30,
          ),
          child: Card(
            margin: EdgeInsets.all(20.0),
            color: cardColor,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textBody,
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [date, time],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
