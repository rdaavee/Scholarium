import 'package:flutter/material.dart';
import 'package:isHKolarium/features/screens/screen_notification/notification_screen.dart';
import 'package:isHKolarium/features/screens/screen_profile/profile_screen.dart';
import 'package:isHKolarium/features/screens/screen_schedule/schedule_screen.dart';
import 'package:isHKolarium/features/screens/screen_student/student_home.dart';

Widget getPage(int index) {
  switch (index) {
    case 1:
      return const ScheduleScreen();
    case 2:
      return const NotificationScreen();
    case 3:
      return const ProfileScreen();
    default:
      return const StudentHomeScreen();
  }
}
