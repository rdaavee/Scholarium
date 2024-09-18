import 'package:flutter/material.dart';
import 'package:isHKolarium/config/constants/colors.dart';

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
      child: Card(
        margin: const EdgeInsets.all(10.0),
        color: cardColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: SizedBox(
                height: 150.0,
                width: double.infinity,
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
                      ColorPalette.accentBlack.withOpacity(.8),
                      ColorPalette.accentWhite.withOpacity(.5),
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
