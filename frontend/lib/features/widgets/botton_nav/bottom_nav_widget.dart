import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/blocs/bloc_bottom_nav/bottom_nav_bloc.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:isHKolarium/features/screens/screen_admin/admin_home_page.dart';
import 'package:isHKolarium/features/screens/screen_admin/read_screen.dart';
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
            icon: Image.asset('assets/icons/home.png', width: 24, height: 24),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon:
                Image.asset('assets/icons/calendar.png', width: 24, height: 24),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/bell.png', width: 24, height: 24),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon:
                Image.asset('assets/icons/profile.png', width: 24, height: 24),
            label: 'Profile',
          ),
        ],
      ),
    );
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
        return const ScheduleScreen();
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
        return const ScheduleScreen();
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
        return const AnnouncementsScreen(role: "Admin");
      case 3:
        return const ProfileScreen();
      default:
        return const AdminHomeScreen();
    }
  }
}
