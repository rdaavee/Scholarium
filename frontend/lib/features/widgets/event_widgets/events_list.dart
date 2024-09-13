import 'package:flutter/material.dart';
import 'package:isHKolarium/features/widgets/event_widgets/events_card.dart';

class EventsList extends StatelessWidget {
  final List<String> eventsImages = [
    'assets/images/img1.png',
    'assets/images/img2.png',
    'assets/images/img3.png',
    'assets/images/img4.png',
    'assets/images/img5.png',
    'assets/images/img6.png',
    'assets/images/img7.png',
    'assets/images/img8.png',
    'assets/images/img9.png',
    'assets/images/img10.png',
  ];

  final List<String> eventsNames = [
    'LEADERSHIP CAMP',
    'KOMSAYAHAN 2024',
    'CITE GENERAL ASSEMBLY 2024',
    'MASS BLOOD DONATION',
    'Community Baratilyo',
    'KAPEHAN at KAMUSTAHAN',
    'CITE STUDENT ONBOARDING ORIENTATION',
    'FIRST WEEK HI',
    'BRIGADA ESKWELA',
    'NAMEPLATING CEREMONY',
  ];

  EventsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: eventsImages.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: EventsCard(
            imagePath: eventsImages[index],
            eventName: eventsNames[index],
            cardColor: Colors.white,
          ),
        );
      },
    );
  }
}
