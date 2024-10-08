import 'package:flutter/material.dart';

class ProfileCircle extends StatelessWidget {
  final String profilePicture;
  final VoidCallback? onTap;

  const ProfileCircle({super.key, required this.profilePicture, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, 
      child: CircleAvatar(
        radius: 85,
        backgroundColor: const Color(0xFFECECEC),
        backgroundImage:
            profilePicture.isNotEmpty ? NetworkImage(profilePicture) : null,
        child: profilePicture.isEmpty
            ? Icon(Icons.person, size: 80, color: Colors.grey[800])
            : null,
      ),
    );
  }
}
