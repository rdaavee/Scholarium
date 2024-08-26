import 'package:flutter/material.dart';
import 'package:isHKolarium/constants/colors.dart';
import '../widgets/schedule_header.dart';
import '../widgets/timeline_item.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  List<bool> _completedDuty = List.generate(6, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.accent,
      body: Column(
        children: [
          ScheduleHeader(),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFF0F3F4),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: ListView.builder(
                itemCount: _duties.length,
                itemBuilder: (context, index) {
                  final duty = _duties[index];
                  return GestureDetector(
                    onTap: () {
                      if (!_completedDuty[index]) {
                        setState(() {
                          _completedDuty[index] = true;
                        });
                      }
                    },
                    child: TimelineItem(
                      duty: duty,
                      isCompleted: _completedDuty[index],
                      color: _completedDuty[index] ? Colors.green : Colors.grey,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  final List<Map<String, String>> _duties = [
    {
      'date': '10 \nSept',
      'dutyTitle': 'Subject or Course name',
      'professorName': 'Name of Professor',
      'roomName': 'Room name',
      'timeInAndOut': '10:30 - 12:00'
    },
    {
      'date': '11 \nSept',
      'dutyTitle': 'Subject or Course name',
      'professorName': 'Name of Professor',
      'roomName': 'Room name',
      'timeInAndOut': '10:30 - 12:00'
    },
    {
      'date': '12 \nSept',
      'dutyTitle': 'Subject or Course name',
      'professorName': 'Name of Professor',
      'roomName': 'Room name',
      'timeInAndOut': '10:30 - 12:00'
    },
    {
      'date': '13 \nSept',
      'dutyTitle': 'Subject or Course name',
      'professorName': 'Name of Professor',
      'roomName': 'Room name',
      'timeInAndOut': '10:30 - 12:00'
    },
    {
      'date': '14 \nSept',
      'dutyTitle': 'Subject or Course name',
      'professorName': 'Name of Professor',
      'roomName': 'Room name',
      'timeInAndOut': '10:30 - 12:00'
    },
    {
      'date': '15 \nSept',
      'dutyTitle': 'Subject or Course name',
      'professorName': 'Name of Professor',
      'roomName': 'Room name',
      'timeInAndOut': '10:30 - 12:00'
    },
  ];
}
