import 'package:flutter/material.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:isHKolarium/features/screens/screen_message/message_page.dart';
import 'package:isHKolarium/features/screens/screen_message/search_user_page.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isBackButton;
  const AppBarWidget(
      {super.key, required this.title, required this.isBackButton});

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
              leading: null,
              automaticallyImplyLeading: isBackButton,
              iconTheme: const IconThemeData(color: ColorPalette.accentWhite),
              backgroundColor: ColorPalette.primary.withOpacity(0.5),
              toolbarHeight: 130,
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              // builder: (context) => MessageScreen(senderId: '03-0000-00001', receiverId: '03-0000-00002',)));
                              builder: (context) => SearchUserScreen()));
                    },
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
