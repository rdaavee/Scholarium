import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:isHKolarium/features/screens/screen_message/search_user_page.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isBackButton;

  const AppBarWidget({
    super.key,
    required this.title,
    required this.isBackButton,
  });

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
          Align(
            alignment: Alignment.center,
            child: AppBar(
              leading: isBackButton
                  ? IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: ColorPalette.accentWhite,
                        size: 13.0,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  : null,
              automaticallyImplyLeading: false,
              iconTheme: const IconThemeData(color: ColorPalette.accentWhite),
              backgroundColor: ColorPalette.primary.withOpacity(0.5),
              toolbarHeight: 130,
              elevation: 0,
              title: Container(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                    color: ColorPalette.accentWhite,
                  ),
                ),
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.only(top: 1, right: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorPalette.accentWhite.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        CupertinoIcons.chat_bubble_fill,
                        color: ColorPalette.accentWhite,
                        size: 20,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchUserScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
