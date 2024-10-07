import 'package:flutter/cupertino.dart';
import 'package:isHKolarium/features/screens/screen_admin/admin_home_screen.dart';
import 'package:isHKolarium/features/screens/screen_admin/create_announcement_screen.dart';
import 'package:isHKolarium/features/screens/screen_admin/create_schedule_screen.dart';
import 'package:isHKolarium/features/screens/screen_login/login_page.dart';
import 'package:isHKolarium/features/screens/screen_onboard/onboard_screen.dart';

Map<String, WidgetBuilder> routes = {
  OnboardScreen.routeName: (context) => const OnboardScreen(),
  LoginPage.routeName: (context) => const LoginPage(),

  //admin
  '/dashboard': (context) => AdminHomeScreen(),
  '/announcement': (context) => AnnouncementFormScreen(role: 'admin'),
  '/schedule': (context) => SetScheduleScreen(),
};
