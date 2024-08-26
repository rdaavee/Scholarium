import 'package:flutter/material.dart';
import 'package:isHKolarium/features/profile/ui/profile_screen.dart';
import 'package:isHKolarium/features/schedule/ui/schedule_screen.dart';
import 'package:isHKolarium/features/students/ui/student_home.dart';

Widget getPage(int index) {
  switch (index) {
    case 1:
      return const ScheduleScreen();
    case 2:
      return const Text('Notification Page');
    case 3:
      return const ProfileScreen();
    default:
      return const StudentHome();
  }
}
