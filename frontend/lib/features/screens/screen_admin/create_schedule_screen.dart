// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isHKolarium/api/implementations/admin_repository_impl.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/api/models/notifications_model.dart';
import 'package:isHKolarium/api/models/schedule_model.dart';
import 'package:isHKolarium/api/models/user_model.dart';
import 'package:isHKolarium/blocs/bloc_admin/admin_bloc.dart';
import 'package:isHKolarium/features/widgets/admin_widgets/room_textfield.dart';
import 'package:isHKolarium/features/widgets/admin_widgets/subject_textfield.dart';
import 'package:isHKolarium/features/widgets/app_bar.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:isHKolarium/features/widgets/label_text_widget.dart';

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
  late UserModel userProfile;
  List<UserModel>? users;
  final adminRepositoryImpl = AdminRepositoryImpl();
  late AdminBloc adminBloc;
  final List<Map<String, String>> professors = [];
  final List<Map<String, String>> students = [];

  @override
  void initState() {
    super.initState();
    initialize();
  }

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
      final adminRepository = AdminRepositoryImpl();
      final globalRepository = GlobalRepositoryImpl();
      adminBloc = AdminBloc(adminRepository, globalRepository);
      final users = await adminRepositoryImpl.fetchAllUsers();
      userProfile = await globalRepository.fetchUserProfile();

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
    String formattedTime = timeTo24HourMap[selectedTimeSlot] ?? '';
    String formattedDate = selectedDate != null
        ? DateFormat('yyyy-MM-dd').format(selectedDate!)
        : '';
    print("Selected Student: $selectedStudent");
    print("Selected Date: $formattedDate");
    print("Selected Professor: $selectedProfessor");
    print("Selected Time Slot: $formattedTime");
    final schedule = ScheduleModel(
      schoolID: selectedStudent,
      room: "room",
      block: "block",
      subject: "subject",
      profID: selectedProfessor,
      professor: "David Aldrin",
      department: "department",
      time: formattedTime,
      date: formattedDate,
      isActive: false,
      isCompleted: "pending",
    );

    final notification = NotificationsModel(
        sender: userProfile.schoolID,
        senderName: "${userProfile.firstName} ${userProfile.lastName}",
        receiverName: selectedStudent,
        title: "Schedule Duty",
        role: "Admin",
        message:
            "A Schedule has been assign to you. \n You have been assigned a schedule to: Professor $selectedProfessor, \n Room: room, \n Subject: subject,\n time: $formattedTime \n date: $formattedDate ",
        status: false,
        profilePicture: userProfile.profilePicture);
    try {
      adminBloc.add(CreateScheduleAndNotificationEvent(schedule, notification));
      print("Schedule uploaded successfully");
      print("Notification uploaded successfully");
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
            LabelTextWidget(title: 'Select Date'),
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
            LabelTextWidget(title: 'Select Time'),
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
            LabelTextWidget(title: 'Select Professor'),
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
            LabelTextWidget(title: 'Select Student'),
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
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: RoomTextfield(labelText: 'Enter a room'),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: SubjectTextfield(labelText: 'Enter a subject'),
                ),
              ],
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
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
                      ? () async {
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
