import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:isHKolarium/features/widgets/timeline_card.dart';

class TimelineItem extends StatelessWidget {
  final Map<String, dynamic> duty;
  final Color color;

  TimelineItem({
    required this.duty,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final String? completionStatus = duty['completed'] as String?;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Container(
            width: 75,
            alignment: Alignment.centerRight,
            child: Text(
              _formatDate(duty['date'].toString()), // Ensure it's a string
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Colors.grey[600],
              ),
            ),
          ),
        ),
        Expanded(
          child: TimelineTile(
            alignment: TimelineAlign.manual,
            lineXY: 0.1,
            indicatorStyle: IndicatorStyle(
              width: 20,
              color: _getIndicatorColor(completionStatus),
              iconStyle: IconStyle(
                iconData: _getIndicatorIcon(completionStatus),
                color: Colors.white,
              ),
            ),
            afterLineStyle: const LineStyle(
              color: Colors.grey,
              thickness: 1.0,
            ),
            beforeLineStyle: const LineStyle(
              color: Colors.grey,
              thickness: 1.0,
            ),
            endChild: TimelineCard(
              dutyTitle: duty['subject'].toString(), // Ensure it's a string
              professorName: duty['teacher'].toString(), // Ensure it's a string
              roomName: duty['room'].toString(), // Ensure it's a string
              timeInAndOut: duty['time'].toString(), // Ensure it's a string
              isCompleted: completionStatus == "true",
              isNotCompleted: completionStatus == "false",
              cardColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  // Helper function to get the color of the indicator based on completion status
  Color _getIndicatorColor(String? completionStatus) {
    switch (completionStatus?.toLowerCase()) {
      case 'true':
        return Colors.green;
      case 'false':
        return Colors.red;
      case 'pending':
        return Colors.grey; // Color for pending status
      default:
        return Colors.grey; // Default color if empty or unknown
    }
  }

  // Helper function to get the icon of the indicator based on completion status
  IconData _getIndicatorIcon(String? completionStatus) {
    switch (completionStatus?.toLowerCase()) {
      case 'true':
        return Icons.check;
      case 'false':
        return Icons.close;
      case 'pending':
        return Icons.radio_button_unchecked; // Icon for pending status
      default:
        return Icons.radio_button_unchecked; // Default icon if empty or unknown
    }
  }

  // Helper function to format the date
  String _formatDate(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    final List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final String formattedDate =
        '${months[parsedDate.month - 1]}. ${parsedDate.day}, ${parsedDate.year}';
    return formattedDate;
  }
}