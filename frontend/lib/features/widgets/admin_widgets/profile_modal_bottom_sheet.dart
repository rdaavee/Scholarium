import 'package:flutter/material.dart';

class ProfileModalBottomSheet extends StatelessWidget {
  final String name;
  final String schoolId;
  final String role;
  final bool isActive;

  const ProfileModalBottomSheet({
    super.key,
    required this.name,
    required this.schoolId,
    required this.role,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 750,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 30),
            const Center(
              child: CircleAvatar(
                radius: 75.0,
                backgroundColor: Color(0xFFEDEDED),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Color(0xFF6D7278),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                schoolId,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF6D7278),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                role,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF6D7278),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Chip(
                label: Text(
                  isActive ? 'Active' : 'Inactive',
                  style: const TextStyle(
                    fontSize: 9,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                backgroundColor: isActive
                    ? const Color(0xFF6DD400).withOpacity(0.85)
                    : Colors.red.withOpacity(0.85),
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: isActive
                          ? const Color(0xFF6DD400).withOpacity(0.85)
                          : Colors.red.withOpacity(0.85),
                    ),
                    borderRadius: BorderRadius.circular(99)),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(
              thickness: 0.2,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            Container(
              height: 250,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  // Action when send message is clicked
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                ),
                child: const Text(
                  'Send Message',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
