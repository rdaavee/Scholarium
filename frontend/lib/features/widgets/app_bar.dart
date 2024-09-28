import 'package:flutter/material.dart';
import 'package:isHKolarium/config/constants/colors.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isBackButton;
  const AppBarWidget({super.key, required this.title, required this.isBackButton});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70.0),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/image.jpg',
              fit: BoxFit.cover,
            ),
          ),
          AppBar(
            leading: null,
            automaticallyImplyLeading: isBackButton,
            iconTheme: const IconThemeData(color: ColorPalette.accentWhite),
            backgroundColor: ColorPalette.primary.withOpacity(0.6),
            elevation: 0,
            title: Container(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                  color: ColorPalette.accentWhite,
                ),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(top: 5),
                padding: const EdgeInsets.only(right: 20),
                child: IconButton(
                  icon: Image.asset(
                    'assets/icons/message.png',
                    width: 27,
                    height: 27,
                    color: ColorPalette.accentWhite,
                  ),
                  onPressed: () {
                    // logic here
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
