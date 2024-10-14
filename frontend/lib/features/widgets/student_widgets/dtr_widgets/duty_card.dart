// duty_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isHKolarium/api/models/user_model.dart';
import 'package:isHKolarium/features/widgets/profile_widgets/profile_modal_bottom_sheet.dart';

class DutyCard extends StatelessWidget {
  final Color cardColor;
  final String time;
  final String roomName;
  final List<UserModel> students;

  const DutyCard({
    super.key,
    required this.cardColor,
    required this.time,
    required this.roomName,
    required this.students,
  });

  @override
  Widget build(BuildContext context) {
    String formatTimeToAmPm(String time) {
    DateTime dateTime = DateFormat('HH:mm:ss').parse(time);
    return DateFormat('hh:mm a').format(dateTime);
  }
    String formattedTime = formatTimeToAmPm(time.toString());
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Facilitator Duty',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              formattedTime,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              roomName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'People',
              style: TextStyle(
                fontSize: 11,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              children: students.map((student) {
                return GestureDetector(
                  onTap: () {
                    _showBottomSheet(
                      context,
                      student.schoolID.toString(),
                    );
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: student.profilePicture != null
                        ? NetworkImage(student.profilePicture!)
                        : null,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(
    BuildContext context,
    String schoolId,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return ProfileModalBottomSheet(
          schoolId: schoolId,
        );
      },
    );
  }
}
