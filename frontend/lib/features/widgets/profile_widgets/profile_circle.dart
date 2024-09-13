import 'package:flutter/material.dart';

class ProfileCircle extends StatelessWidget {
  final String profilePictureUrl; // Add this field

  const ProfileCircle(
      {super.key, required this.profilePictureUrl}); // Add this parameter

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 85, // Adjust the size as needed
      backgroundColor: const Color(0xFFECECEC),
      backgroundImage: NetworkImage(profilePictureUrl),
      child: profilePictureUrl.isEmpty
          ? Icon(Icons.person, size: 80, color: Colors.grey[800])
          : null,
    );
  }
}
