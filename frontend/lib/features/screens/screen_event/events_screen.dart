import 'package:flutter/material.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:isHKolarium/features/widgets/event_widgets/events_list.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.primary,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/image.jpg',
                fit: BoxFit.cover,
              ),
            ),
            AppBar(
              backgroundColor: ColorPalette.primary.withOpacity(0.6),
              iconTheme: const IconThemeData(
                color: Colors.white,
              ),
              elevation: 0,
              title: Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.only(left: 5),
                child: const Text(
                  "DTR",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                    color: ColorPalette.accentWhite,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF0F3F4),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: EventsList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
