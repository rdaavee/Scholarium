import 'package:flutter/material.dart';
import 'package:isHKolarium/constants/colors.dart';
import 'package:isHKolarium/constants/paddings.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback onPress;
  final String title;

  const LoginButton({
    Key? key,
    required this.onPress,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        margin: EdgeInsets.only(
          left: defaultPadding,
          right: defaultPadding,
        ),
        padding: EdgeInsets.only(
          left: defaultPadding,
          right: defaultPadding,
        ),
        width: double.infinity,
        height: 55.0,
        decoration: BoxDecoration(
          color: ColorPalette.darkGreen,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
