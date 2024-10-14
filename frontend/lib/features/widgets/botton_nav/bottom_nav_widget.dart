import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/blocs/bloc_bottom_nav/bottom_nav_bloc.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:isHKolarium/features/screens/screen_admin/admin_home_screen.dart';
import 'package:isHKolarium/features/screens/screen_admin/user_data_screen.dart';
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
        if (state is BottomNavLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is BottomNavLoadedSuccessState) {
          final selectedIndex = state.selectedIndex;
          final unreadCount = state.unreadCount;

          return Scaffold(
            backgroundColor: ColorPalette.accentBlack,
            body: _getRoleSpecificPage(selectedIndex),
            bottomNavigationBar:
                _buildBottomNavigationBar(context, selectedIndex, unreadCount),
          );
        }

        // Trigger initial event and fetch unread count on first build
        context.read<BottomNavBloc>().add(BottomNavInitialEvent());
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildBottomNavigationBar(
      BuildContext context, int selectedIndex, int unreadCount) {
    return BottomNavigationBarTheme(
      data: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        selectedItemColor: ColorPalette.primary,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(
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
            icon: Stack(
              children: [
                _getIconForRole(isRole, 'notification'),
                if (unreadCount > 0) _buildUnreadBadge(unreadCount),
              ],
            ),
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

  Widget _buildUnreadBadge(int unreadCount) {
    return Positioned(
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        constraints: const BoxConstraints(
          minWidth: 16,
          minHeight: 16,
        ),
        child: Text(
          '$unreadCount',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
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
        return const ScheduleScreen(role: 'Student', isAppBarBack: false,);
      case 2:
        return const NotificationScreen(isRole: 'Student',);
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
        return const ScheduleScreen(role: 'Professor', isAppBarBack: false,);
      case 2:
        return const NotificationScreen(isRole: 'Professor',);
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
        return const NotificationScreen(isRole: 'Admin',);
      case 3:
        return const ProfileScreen();
      default:
        return const AdminHomeScreen();
    }
  }

  String _getLabelForRole(String role, String itemType) {
    switch (itemType) {
      case 'home':
        return 'Home';
      case 'schedule':
        return role == 'Admin' ? 'Users' : 'Schedule';
      case 'notification':
        return 'Notifications';
      case 'profile':
        return 'Profile';
      default:
        return 'Item';
    }
  }

  Icon _getIconForRole(String role, String itemType) {
    switch (itemType) {
      case 'home':
        return const Icon(CupertinoIcons.home);
      case 'schedule':
        return role == 'Admin'
            ? const Icon(CupertinoIcons.person_2_square_stack)
            : const Icon(CupertinoIcons.calendar);
      case 'notification':
        return const Icon(CupertinoIcons.bell);
      case 'profile':
        return const Icon(CupertinoIcons.profile_circled);
      default:
        return const Icon(CupertinoIcons.question);
    }
  }
}
