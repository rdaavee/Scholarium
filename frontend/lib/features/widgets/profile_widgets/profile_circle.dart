import 'package:flutter/material.dart';
import 'package:isHKolarium/config/constants/colors.dart';

class ProfileCircle extends StatelessWidget {
  final String profilePicture;
  final VoidCallback onTap;

  const ProfileCircle({
    super.key,
    required this.profilePicture,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        height: 150,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: profilePicture.isNotEmpty
                ? NetworkImage(profilePicture)
                : AssetImage('assets/images/avatar.png') as ImageProvider,
            scale: 1.0,
            fit: BoxFit.contain,
          ),
          border: Border.all(
            color: ColorPalette.gray,
            width: 1.0,
          ),
        ),
      ),
    );
  }
}
