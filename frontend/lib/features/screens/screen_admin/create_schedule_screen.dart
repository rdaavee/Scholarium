// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

class SetScheduleScreen extends StatefulWidget {
  const SetScheduleScreen({super.key});

  @override
  SetScheduleScreenState createState() => SetScheduleScreenState();
}

class SetScheduleScreenState extends State<SetScheduleScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;
  String? selectedProfessor;
  String? selectedProfessorId;
  String? selectedStudent;
  String? role;
  String? id;
  List<UserModel>? users;
  late UserModel userProfile;
  late AdminBloc adminBloc;
  final adminRepositoryImpl = AdminRepositoryImpl();
  final TextEditingController roomController = TextEditingController();
  final TextEditingController taskController = TextEditingController();
  final List<Map<String, String>> professors = [];
  final List<Map<String, String>> students = [];

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<String?> _getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }

  Future<String?> _getID() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('schoolID');
  }

  Future<void> initialize() async {
    role = await _getRole();
    id = await _getID();
    try {
      final adminRepository = AdminRepositoryImpl();
      final globalRepository = GlobalRepositoryImpl();
      adminBloc = AdminBloc(adminRepository, globalRepository);
      final users = await adminRepositoryImpl.fetchAllUsers();
      userProfile = await globalRepository.fetchUserProfile();

      if (role == "Professor") {
        print(userProfile.schoolID.toString());
        professors.add({
          'school_id': userProfile.schoolID.toString(),
          'name': "${userProfile.firstName} ${userProfile.lastName}"
        });
        for (var user in users) {
          if (user.role == "Student") {
            students.add({
              'school_id': user.schoolID.toString(),
              'name': "${user.firstName} ${user.lastName}"
            });
          }
        }
      } else {
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
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  final DateFormat timeFormatter = DateFormat('hh:mm a');

  String formatTimeOfDay(TimeOfDay? time) {
    if (time == null) return '';
    final now = DateTime.now();
    final formattedTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return timeFormatter.format(formattedTime);
  }

  Future<void> selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        if (isStart) {
          selectedStartTime = pickedTime;
          selectedEndTime = null;
        } else {
          selectedEndTime = pickedTime;
        }
      });
    }
  }

  Future<void> uploadSchedule() async {
    String formattedDate = selectedDate != null
        ? DateFormat('yyyy-MM-dd').format(selectedDate!)
        : '';
    if (roomController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please input a room.')),
      );
      return;
    }
    if (taskController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please input a task.')),
      );
      return;
    }
    final schedule = ScheduleModel(
      schoolID: selectedStudent,
      room: roomController.text,
      block: "block",
      task: taskController.text,
      profID: selectedProfessor,
      professor: "",
      department: "department",
      timeIn: formatTimeOfDay(selectedStartTime),
      timeOut: formatTimeOfDay(selectedEndTime),
      date: formattedDate,
      isActive: false,
      isCompleted: "pending",
    );
    print(formatTimeOfDay(selectedStartTime));

    final notification = NotificationsModel(
        sender: userProfile.schoolID,
        senderName: "${userProfile.firstName} ${userProfile.lastName}",
        receiverName: selectedStudent,
        title: "Schedule Duty",
        role: "Admin",
        message:
            "  class at room ${roomController.text}, on $formattedDate at ${formatTimeOfDay(selectedStartTime)} to ${formatTimeOfDay(selectedEndTime)} as ${taskController.text}",
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
      body: SingleChildScrollView(
        // Added scroll view to handle overflow
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabelTextWidget(title: 'Select Date'),
              const SizedBox(height: 10),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  color: Colors.grey[50],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedDate != null
                            ? '${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}'
                            : 'Select',
                        style: const TextStyle(
                          color: ColorPalette.accentBlack,
                          fontSize: 11,
                        ),
                      ),
                      const Icon(CupertinoIcons.calendar,
                          color: Color(0xFF6D7278)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              LabelTextWidget(title: 'Select Time'),
              const SizedBox(height: 10),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  hintText: selectedStartTime != null
                      ? formatTimeOfDay(selectedStartTime)
                      : "Select start time",
                  hintStyle: TextStyle(fontSize: 11),
                  suffixIcon: const Icon(CupertinoIcons.clock),
                ),
                onTap: () => selectTime(context, true),
              ),
              const SizedBox(height: 16),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  hintText: selectedEndTime != null
                      ? formatTimeOfDay(selectedEndTime)
                      : "Select end time",
                  hintStyle: TextStyle(fontSize: 11),
                  suffixIcon: const Icon(CupertinoIcons.clock),
                ),
                onTap: selectedStartTime != null
                    ? () => selectTime(context, false)
                    : null,
              ),
              const SizedBox(height: 20),
              if (selectedStartTime != null && selectedEndTime != null)
                Text(
                  "The selected time of your duty is from ${formatTimeOfDay(selectedStartTime)} to ${formatTimeOfDay(selectedEndTime)}",
                  style: const TextStyle(fontSize: 10),
                ),
              const SizedBox(height: 30),
              LabelTextWidget(title: 'Select Professor'),
              const SizedBox(height: 10),
              DropdownButton<String>(
                isExpanded: true,
                value: selectedProfessor,
                hint: const Text(
                  "Select Professor",
                  style: TextStyle(fontSize: 12),
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
              const SizedBox(height: 20),
              LabelTextWidget(title: 'Select Student'),
              const SizedBox(height: 10),
              DropdownButton<String>(
                isExpanded: true,
                value: selectedStudent,
                hint: const Text(
                  "Select Student",
                  style: TextStyle(fontSize: 12),
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
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: RoomTextfield(
                      labelText: 'Enter a room',
                      roomController: roomController,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TaskTextfield(
                      labelText: 'Enter a task',
                      taskController: taskController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
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
                            selectedStartTime != null &&
                            selectedProfessor != null
                        ? () async {
                            uploadSchedule();
                          }
                        : null,
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
