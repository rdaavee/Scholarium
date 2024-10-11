import 'package:flutter/material.dart';

class ProfileCircle extends StatelessWidget {
  final String profilePicture;
  final VoidCallback onTap;

  const ProfileCircle({
    Key? key,
    required this.profilePicture,
    required this.onTap,
  }) : super(key: key);

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
            image: NetworkImage(profilePicture),
            scale: 1.0,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
