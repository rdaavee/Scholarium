// duty_card.dart
import 'package:flutter/material.dart';
import 'package:isHKolarium/features/widgets/profile_widgets/profile_modal_bottom_sheet.dart';

class DutyCard extends StatelessWidget {
  final Color cardColor;
  final String time;
  final String roomName;

  const DutyCard({
    required this.cardColor,
    required this.time,
    required this.roomName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Facilitator Duty',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
                letterSpacing: 1.1,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              time,
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 5),
            Text(
              roomName,
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'People',
              style: TextStyle(
                fontSize: 11,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 5),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    _showBottomSheet(context, 'Ranier Tan', '03-0000-00001',
                        'Pantal, Dagupan City', true);
                  },
                  child: CircleAvatar(backgroundColor: Colors.white),
                ),
                SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    _showBottomSheet(context, 'Mark Benedict Abalos',
                        '03-0000-00002', 'Lingayen, Pangasinan', true);
                  },
                  child: CircleAvatar(backgroundColor: Colors.grey[300]),
                ),
                SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    _showBottomSheet(context, 'Olibird Ferrer', '03-0000-00003',
                        'Mangaldan, Pangasinan', true);
                  },
                  child: CircleAvatar(backgroundColor: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(
    BuildContext context,
    String name,
    String schoolId,
    String address,
    bool isActive,
  ) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return ProfileModalBottomSheet(
          name: name,
          schoolId: schoolId,
          address: address,
          isActive: isActive,
        );
      },
    );
  }
}
