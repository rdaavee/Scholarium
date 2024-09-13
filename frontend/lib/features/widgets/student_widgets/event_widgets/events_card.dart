import 'package:flutter/material.dart';

class EventsCard extends StatelessWidget {
  final Text textLabel;
  final Color cardColor;
  final String imageAssetPath;

  const EventsCard({
    super.key,
    required this.textLabel,
    required this.cardColor,
    required this.imageAssetPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: Card(
        margin: const EdgeInsets.all(10.0),
        color: cardColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Stack(
          children: [
            SizedBox(
              height: 150.0,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Image.asset(
                  imageAssetPath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 21, 41, 29).withOpacity(1),
                      const Color(0xFF6DD400).withOpacity(0.3),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: textLabel,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
