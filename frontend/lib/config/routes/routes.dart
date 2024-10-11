import 'package:flutter/cupertino.dart';
import 'package:isHKolarium/features/screens/screen_admin/admin_home_screen.dart';
import 'package:isHKolarium/features/screens/screen_admin/create_announcement_screen.dart';
import 'package:isHKolarium/features/screens/screen_admin/create_schedule_screen.dart';
import 'package:isHKolarium/features/screens/screen_announcement/announcement.dart';
import 'package:isHKolarium/features/screens/screen_login/login_page.dart';
import 'package:isHKolarium/features/screens/screen_onboard/onboard_screen.dart';

Map<String, WidgetBuilder> routes = {
  OnboardScreen.routeName: (context) => const OnboardScreen(),
  LoginPage.routeName: (context) => const LoginPage(),

  //admin
  '/dashboard': (context) => AdminHomeScreen(),
  '/view_announcement': (context) => AnnouncementsScreen(isBackButtonTrue: true),
  '/view_schedule': (context) => SetScheduleScreen(),
  '/create_announcement': (context) => AnnouncementFormScreen(role: 'admin'),
  '/create_schedule': (context) => SetScheduleScreen(),
};
