import 'package:flutter/material.dart';
import 'package:isHKolarium/features/students/ui/schedule_screen.dart';
import 'package:isHKolarium/features/students/ui/student_home.dart';

Widget getPage(int index) {
  switch (index) {
    case 1:
      return ScheduleScreen();
    case 2:
      return Text('Notification Page');
    case 3:
      return Text('Profile Page');
    default:
      return StudentHome();
  }
}
