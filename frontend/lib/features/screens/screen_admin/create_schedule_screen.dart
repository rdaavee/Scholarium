// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:isHKolarium/api/implementations/admin_repository_impl.dart';
import 'package:isHKolarium/api/models/schedule_model.dart';
import 'package:isHKolarium/api/models/user_model.dart';
import 'package:isHKolarium/features/widgets/app_bar.dart';
import 'package:isHKolarium/config/constants/colors.dart';

class SetScheduleScreen extends StatefulWidget {
  const SetScheduleScreen({super.key});

  @override
  SetScheduleScreenState createState() => SetScheduleScreenState();
}

class SetScheduleScreenState extends State<SetScheduleScreen> {
  DateTime? selectedDate;
  String? selectedTimeSlot;
  String? selectedProfessor;
  String? selectedProfessorId;
  String? selectedStudent;
  List<UserModel>? users;
  final adminRepositoryImpl = AdminRepositoryImpl();

  @override
  void initState() {
    super.initState();
    initialize();
  }

  final List<Map<String, String>> professors = [];
  final List<Map<String, String>> students = [];

  final List<String> timeSlots = [
    '7 AM',
    '8 AM',
    '9 AM',
    '10 AM',
    '11 AM',
    '12 PM',
    '1 PM',
    '2 PM',
    '3 PM',
    '4 PM',
    '5 PM',
  ];

  // Mapper for 12-hour to 24-hour time conversion
  final Map<String, String> timeTo24HourMap = {
    '7 AM': '07:00:00',
    '8 AM': '08:00:00',
    '9 AM': '09:00:00',
    '10 AM': '10:00:00',
    '11 AM': '11:00:00',
    '12 PM': '12:00:00',
    '1 PM': '13:00:00',
    '2 PM': '14:00:00',
    '3 PM': '15:00:00',
    '4 PM': '16:00:00',
    '5 PM': '17:00:00',
  };

  Future<void> initialize() async {
    try {
      final users = await adminRepositoryImpl.fetchAllUsers();

      for (var user in users) {
        if (user.role == 'Professor') {
          professors.add({
            'school_id': user.schoolID.toString(),
            'name': "${user.firstName} ${user.lastName}",
          });
        } else if (user.role == 'Student') {
          students.add({
            'school_id': user.schoolID.toString(),
            'name': "${user.firstName} ${user.lastName}",
          });
        }
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> uploadSchedule() async {
    print("Selected Student: $selectedStudent");
    print("Selected Date: $selectedDate");
    print("Selected Professor: $selectedProfessor");
    print("Selected Time Slot: $selectedTimeSlot");

    final schedule = ScheduleModel(
      schoolID: selectedStudent,
      room: "room",
      block: "block",
      subject: "subject",
      profID: selectedProfessor,
      professor: "David Aldrin", // Update as needed
      department: "department", // Update as needed
      time:
          timeTo24HourMap[selectedTimeSlot] ?? '', // Convert to 24-hour format
      date: selectedDate?.toString() ?? '',
      isCompleted: "",
    );
    try {
      await adminRepositoryImpl.createSchedule(schedule);
      print("Schedule uploaded successfully");
      Navigator.pop(context);
    } catch (e) {
      print("Error uploading schedule: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: "Schedule Duty", isBackButton: true),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Date',
              style: TextStyle(
                color: Color(0xFF6D7278),
                fontSize: 15,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(DateTime.now().year + 1),
                );
                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                color: Colors.grey[50],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDate != null
                          ? '${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}'
                          : 'Select',
                      style: TextStyle(
                        color: ColorPalette.accentBlack,
                        fontFamily: 'Manrope',
                        fontSize: 11,
                      ),
                    ),
                    Icon(Icons.calendar_today, color: Color(0xFF6D7278)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Select Time',
              style: TextStyle(
                color: Color(0xFF6D7278),
                fontSize: 15,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: timeSlots.map((slot) {
                return ChoiceChip(
                  labelPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  shape: RoundedRectangleBorder(side: BorderSide.none),
                  label: Text(
                    slot,
                    style: TextStyle(
                      color: ColorPalette.accentBlack,
                      fontFamily: 'Manrope',
                      fontSize: 11,
                    ),
                  ),
                  selected: selectedTimeSlot == slot,
                  onSelected: (bool selected) {
                    setState(() {
                      selectedTimeSlot = selected ? slot : null;
                    });
                  },
                  backgroundColor: Colors.grey[50],
                  selectedColor: ColorPalette.accent,
                );
              }).toList(),
            ),
            SizedBox(height: 30),
            Text(
              'Select Professor',
              style: TextStyle(
                color: Color(0xFF6D7278),
                fontSize: 15,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedProfessor,
              hint: Text(
                "Select Professor",
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 12,
                ),
              ),
              items: professors.map((professor) {
                return DropdownMenuItem<String>(
                  value: professor['school_id'],
                  child: Text(professor['name']!),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedProfessor = value;
                });
              },
            ),
            Text(
              'Select Student',
              style: TextStyle(
                color: Color(0xFF6D7278),
                fontSize: 15,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedStudent,
              hint: Text(
                "Select Student",
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 12,
                ),
              ),
              items: students.map((student) {
                return DropdownMenuItem<String>(
                  value: student['school_id'],
                  child: Text(student['name']!),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedStudent = value;
                });
              },
            ),
            SizedBox(height: 10),
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 30),
                width: MediaQuery.of(context).size.width * .9,
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: ColorPalette.btnColor,
                ),
                child: TextButton(
                  onPressed: selectedDate != null &&
                          selectedTimeSlot != null &&
                          selectedProfessor != null
                      ? () {
                          uploadSchedule();
                        }
                      : null,
                  child: Text(
                    'Confirm',
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Manrope',
                      fontSize: 11.5,
                    ),
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
