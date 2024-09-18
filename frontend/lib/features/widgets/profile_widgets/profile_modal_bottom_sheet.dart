// duty_modal_bottom_sheet.dart
import 'package:flutter/material.dart';

class ProfileModalBottomSheet extends StatelessWidget {
  final String name;
  final String schoolId;
  final String address;
  final bool isActive;

  const ProfileModalBottomSheet({
    super.key,
    required this.name,
    required this.schoolId,
    required this.address,
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
            // Name
            Center(
              child: Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Manrope',
                  fontSize: 24,
                  color: Color(0xFF6D7278),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // School ID
            Center(
              child: Text(
                schoolId,
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 16,
                  color: Color(0xFF6D7278),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Address
            Center(
              child: Text(
                address,
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 16,
                  color: Color(0xFF6D7278),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Active/Inactive Status
            Center(
              child: Chip(
                label: Text(
                  isActive ? 'Active' : 'Inactive',
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 9,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                backgroundColor:
                    isActive ? const Color(0xFF6DD400) : Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: isActive ? const Color(0xFF6DD400) : Colors.red,
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
                  //navigate thru message screen
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
                    fontFamily: 'Manrope',
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
