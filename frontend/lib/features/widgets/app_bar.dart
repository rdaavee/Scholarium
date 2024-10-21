import 'dart:io'; // For platform checking
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
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.only(top: 7.0),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
      ),
      backgroundColor: ColorPalette.primary,
      foregroundColor: Colors.white,
      centerTitle: Platform.isIOS ? true : false,
      leading: isBackButton
          ? Padding(
              padding: const EdgeInsets.only(top: 7.0),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 10,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          : null,
      actions: [
        IconButton(
          icon: const Icon(
            Icons.chat_bubble_outline,
            size: 20,
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SearchUserScreen()));
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
