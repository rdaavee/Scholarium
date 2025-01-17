import 'dart:ui';
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
              child: Stack(
                children: [
                  SizedBox(
                    height: 150.0,
                    width: double.infinity,
                    child: Image.asset(
                      imageAssetPath,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    height: 150.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: ColorPalette.primary.withOpacity(.5),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    color: Colors.grey.withOpacity(0.1),
                    child: textLabel,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
