import 'package:flutter/material.dart';

class AnnouncementCard extends StatelessWidget {
  final Text textLabel;
  final Text textBody;
  final Text date;
  final Text time;
  final String imageUrl;

  const AnnouncementCard({
    super.key,
    required this.textLabel,
    required this.textBody,
    required this.date,
    required this.time,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          height: 170,
          child: Card(
            margin: const EdgeInsets.all(10.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                  image: AssetImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
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
        ),
      ],
    );
  }
}
