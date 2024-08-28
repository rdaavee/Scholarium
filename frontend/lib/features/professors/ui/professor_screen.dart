import 'package:flutter/material.dart';

class ProfessorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hi, Professor'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Post Something'),
                        content: TextField(
                          decoration: InputDecoration(
                            hintText: 'Write your post here...',
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Post'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.person, color: Colors.grey),
                        SizedBox(width: 10),
                        Text(
                          'Post something',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Ongoing Duties',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  DutyCard(
                    color: Colors.green[400]!,
                    time: '7:30AM-9:00AM',
                    location: 'PTC-206',
                  ),
                  SizedBox(height: 16),
                  DutyCard(
                    color: Colors.lightGreen,
                    time: '7:30AM-9:00AM',
                    location: 'PTC-206',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Schedule'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notification'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) {
          // Handle bottom navigation taps here
        },
      ),
    );
  }
}

class DutyCard extends StatelessWidget {
  final Color color;
  final String time;
  final String location;

  const DutyCard({
    required this.color,
    required this.time,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Facilitator Duty',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              time,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(height: 5),
            Text(
              location,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'People',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                SizedBox(width: 10),
                CircleAvatar(backgroundColor: Colors.white),
                SizedBox(width: 5),
                CircleAvatar(backgroundColor: Colors.grey[300]),
                SizedBox(width: 5),
                CircleAvatar(backgroundColor: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }
}