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

  final List<String> eventsDescriptions = [
    'As the new set of Student Leaders arise, new set of adventures unfold. Phinma UPang Flames, are you ready to take on the challenge and have fun? See you this coming May 28-29.',
    'Join us for a 3 day event of College of Information and Technology Education as we celebrate CITEFEST this January 11-13, 2024. See you there!.',
    'Get ready to power up your semester at the CITE General 𝐀𝐬𝐬𝐞𝐦𝐛𝐥𝐲 2024, happening on Friday, July 5th, from 9:00 AM to 11:30 AM at the University Gymnasium..',
    'Happy Hearts Day, PHINMA Ed Family!  Be the reason of someones heartbeat. Here is the schedule for Mass Blood Donation, February 14, 2024, starting 8:30 AM at the University Gymnasium..',
    'The University officially kicks off the 3-day Community Baratilyo From February 15-17, 2024 with the theme “Negosyo ng Kabataan, Puhunan ay Kinabukasan”',
    'We are delighted to invite you to engage, connect, and empower at the upcoming Kapehan at Kumustahan on April 3, 2024 at the PHINMA UPang Gymnasium.',
    'We are excited to invite you to the CITE Students Onboarding Orientation, on July 10, 2024, at 10 AM via Zoom in partnership with Wadhwani Foundation.',
    'PHINMA University of Pangasinan warmly welcomed Senior High School Grade 11 and College Freshmen students with a blast of First Week Hi 2.0 - Kalutan Ed UPang, themed “Biyaheng UPang: Lakbay Tagumpay”',
    'University of Pangasinan joined force again with a shared vision of making lives of others better as Brigada Eskwela 2024 kicked off on July 23 to 26, 2024 at Dagupan National High School and Urdaneta City National High School.',
    'On the 13th of August, we celebrate those who have persevered on the academic battlefield. This will commemorate their efforts and become a nexus event for their nearing advancements. This event marks a milestone that paves the way to their upcoming Capping, Pinning and Candle Lighting Ceremony the zenith of their life as Student Nurses',
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
            description: eventsDescriptions[index], // Providing the description
            cardColor: Colors.white,
          ),
        );
      },
    );
  }
}
