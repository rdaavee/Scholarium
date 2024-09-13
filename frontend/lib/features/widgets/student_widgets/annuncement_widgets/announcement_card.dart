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
        Container(
          height: 170,
          margin: const EdgeInsets.only(
            top: 30,
          ),
          child: Card(
            margin: const EdgeInsets.all(10.0),
            color: cardColor,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textLabel,
                  textBody,
                  const SizedBox(height: 16),
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
