import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/constants/colors.dart';
import 'package:isHKolarium/features/bottom_nav/bloc/bottom_nav_bloc.dart';
import 'package:isHKolarium/features/students/widgets/page_provider.dart';

class BottomNavWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavBloc, BottomNavState>(
      builder: (context, state) {
        int selectedIndex = 0;
        if (state is BottomNavItemSelectedState) {
          selectedIndex = state.selectedIndex;
        }

        return Scaffold(
          backgroundColor: ColorPalette.accentBlack,
          body: Center(
            child: getPage(selectedIndex),
          ),
          bottomNavigationBar: BottomNavigationBarTheme(
            data: BottomNavigationBarThemeData(
              selectedItemColor: ColorPalette.accent,
              unselectedItemColor: Colors.grey,
              selectedLabelStyle: TextStyle(
                fontFamily: 'Inter',
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
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                  backgroundColor: Colors.white,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month),
                  label: 'Schedule',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications),
                  label: 'Notification',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle_rounded),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
