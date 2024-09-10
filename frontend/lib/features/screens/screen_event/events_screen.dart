import 'package:flutter/material.dart';

class EventsScreen extends StatefulWidget {
  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Events'),
          backgroundColor: Colors.green,
        ),
        body: CurvedWhiteContainer(
          child: EventList(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.schedule),
              label: 'Schedule',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notification',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class CurvedWhiteContainer extends StatelessWidget {
  final Widget child;

  CurvedWhiteContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      child: child,
    );
  }
}

class EventList extends StatelessWidget {
  final List<String> eventImages = [
    'assets/img1.png',
    'assets/img2.png',
    'assets/img3.png',
    'assets/img4.png',
    'assets/img5.png',
    'assets/img6.png',
    'assets/img7.png',
    'assets/img8.png',
    'assets/img9.png',
    'assets/img10.png',
  ];

  final List<String> eventNames = [
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

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: eventImages.length, 
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: EventCard(
            imagePath: eventImages[index],
            eventName: eventNames[index], 
          ),
        );
      },
    );
  }
}

class EventCard extends StatelessWidget {
  final String imagePath;
  final String eventName;

  const EventCard({required this.imagePath, required this.eventName});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.asset(
            imagePath, 
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              eventName, 
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
