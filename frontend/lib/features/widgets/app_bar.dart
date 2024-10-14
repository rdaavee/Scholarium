import 'package:flutter/material.dart';
import 'package:isHKolarium/config/constants/colors.dart';

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
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
        ),
      ),
      backgroundColor: ColorPalette.primary,
      foregroundColor: Colors.white,
      leading: isBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
