import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:isHKolarium/blocs/bloc_bottom_nav/bottom_nav_bloc.dart';
import 'package:isHKolarium/features/widgets/botton_nav/page_provider.dart';

class BottomNavWidget extends StatelessWidget {
  const BottomNavWidget({super.key});

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
            data: const BottomNavigationBarThemeData(
              backgroundColor: Colors.transparent,
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
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Image.asset('assets/icons/home.png',
                      width: 24, height: 24),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset('assets/icons/calendar.png',
                      width: 24, height: 24),
                  label: 'Schedule',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset('assets/icons/bell.png',
                      width: 24, height: 24),
                  label: 'Notification',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset('assets/icons/profile.png',
                      width: 24, height: 24),
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
