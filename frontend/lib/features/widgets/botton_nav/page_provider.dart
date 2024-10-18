import 'package:flutter/material.dart';
import 'package:isHKolarium/features/screens/screen_notification/notification_screen.dart';
import 'package:isHKolarium/features/screens/screen_profile/profile_screen.dart';
import 'package:isHKolarium/features/screens/screen_schedule/schedule_screen.dart';
import 'package:isHKolarium/features/screens/screen_student/student_home.dart';

Widget getPage(int index) {
  switch (index) {
    case 1:
      return const ScheduleScreen(
        role: 'Student',
        isAppBarBack: false,
        isAdmin: 'No',
      );
    case 2:
      return const NotificationScreen(
        isRole: 'Student',
      );
    case 3:
      return const ProfileScreen();
    default:
      return const StudentHomeScreen();
  }
}
