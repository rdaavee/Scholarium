import 'package:flutter/material.dart';

class EventsCard extends StatelessWidget {
  final String imagePath;
  final String eventName;

  const EventsCard({super.key, required this.imagePath, required this.eventName});

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
              style: const TextStyle(
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