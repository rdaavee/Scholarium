import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/blocs/bloc_bottom_nav/bottom_nav_bloc.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:isHKolarium/features/screens/screen_admin/admin_home_screen.dart';
import 'package:isHKolarium/features/screens/screen_admin/user_data_screen.dart';
import 'package:isHKolarium/features/screens/screen_announcement/announcement.dart';
import 'package:isHKolarium/features/screens/screen_notification/notification_screen.dart';
import 'package:isHKolarium/features/screens/screen_professor/professor_screen.dart';
import 'package:isHKolarium/features/screens/screen_profile/profile_screen.dart';
import 'package:isHKolarium/features/screens/screen_schedule/schedule_screen.dart';
import 'package:isHKolarium/features/screens/screen_student/student_home.dart';

class BottomNavWidget extends StatelessWidget {
  final String isRole;

  const BottomNavWidget({super.key, required this.isRole});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavBloc, BottomNavState>(
      builder: (context, state) {
        final selectedIndex =
            state is BottomNavItemSelectedState ? state.selectedIndex : 0;

        return Scaffold(
          backgroundColor: ColorPalette.accentBlack,
          body: Center(
            child: _getRoleSpecificPage(selectedIndex),
          ),
          bottomNavigationBar:
              _buildBottomNavigationBar(context, selectedIndex),
        );
      },
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context, int selectedIndex) {
    return BottomNavigationBarTheme(
      data: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        selectedItemColor: ColorPalette.primary,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          context.read<BottomNavBloc>().add(BottomNavItemSelected(index));
        },
        items: [
          BottomNavigationBarItem(
            icon: _getIconForRole(isRole, 'home'),
            label: _getLabelForRole(isRole, 'home'),
          ),
          BottomNavigationBarItem(
            icon: _getIconForRole(isRole, 'schedule'),
            label: _getLabelForRole(isRole, 'schedule'),
          ),
          BottomNavigationBarItem(
            icon: _getIconForRole(isRole, 'notification'),
            label: _getLabelForRole(isRole, 'notification'),
          ),
          BottomNavigationBarItem(
            icon: _getIconForRole(isRole, 'profile'),
            label: _getLabelForRole(isRole, 'profile'),
          ),
        ],
      ),
    );
  }

  String _getLabelForRole(String role, String itemType) {
    switch (itemType) {
      case 'home':
        return role == 'Student'
            ? 'Home'
            : role == 'Professor'
                ? 'Home'
                : 'Home';
      case 'schedule':
        return role == 'Student'
            ? 'Schedule'
            : role == 'Professor'
                ? 'Schedule'
                : 'Users';
      case 'notification':
        return role == 'Student'
            ? 'Notifications'
            : role == 'Professor'
                ? 'Notifications'
                : 'Announcements';
      case 'profile':
        return role == 'Student'
            ? 'Profile'
            : role == 'Professor'
                ? 'Profile'
                : 'Profile';
      default:
        return 'Item';
    }
  }

  Widget _getRoleSpecificPage(int index) {
    switch (isRole) {
      case "Student":
        return _getStudentPages(index);
      case "Professor":
        return _getProfessorPages(index);
      case "Admin":
        return _getAdminPages(index);
      default:
        return const Scaffold(body: Center(child: Text('No Data Available')));
    }
  }

  Widget _getStudentPages(int index) {
    switch (index) {
      case 0:
        return const StudentHomeScreen();
      case 1:
        return const ScheduleScreen(role: 'Student',);
      case 2:
        return const NotificationScreen();
      case 3:
        return const ProfileScreen();
      default:
        return const StudentHomeScreen();
    }
  }

  Widget _getProfessorPages(int index) {
    switch (index) {
      case 0:
        return const ProfessorHomeScreen();
      case 1:
        return const ScheduleScreen(role: 'Professor',);
      case 2:
        return const NotificationScreen();
      case 3:
        return const ProfileScreen();
      default:
        return const ProfessorHomeScreen();
    }
  }

  Widget _getAdminPages(int index) {
    switch (index) {
      case 0:
        return const AdminHomeScreen();
      case 1:
        return const UserDataScreen();
      case 2:
        return const AnnouncementsScreen(isBackButtonTrue: false,);
      case 3:
        return const ProfileScreen();
      default:
        return const AdminHomeScreen();
    }
  }

  Icon _getIconForRole(String role, String itemType) {
    switch (itemType) {
      case 'home':
        return Icon(role == 'Student'
            ? CupertinoIcons.home
            : role == 'Professor'
                ? CupertinoIcons.home
                : CupertinoIcons.home);
      case 'schedule':
        return Icon(role == 'Student'
            ? CupertinoIcons.calendar
            : role == 'Professor'
                ? CupertinoIcons.calendar
                : CupertinoIcons.person_2_square_stack);
      case 'notification':
        return Icon(role == 'Student'
            ? CupertinoIcons.bell
            : role == 'Professor'
                ? CupertinoIcons.bell
                : CupertinoIcons.bell);
      case 'profile':
        return Icon(role == 'Student'
            ? CupertinoIcons.profile_circled
            : role == 'Professor'
                ? CupertinoIcons.profile_circled
                : CupertinoIcons.profile_circled);
      default:
        return const Icon(CupertinoIcons.question);
    }
  }
}
