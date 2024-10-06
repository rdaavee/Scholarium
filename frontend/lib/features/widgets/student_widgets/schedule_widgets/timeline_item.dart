import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:isHKolarium/features/widgets/student_widgets/schedule_widgets/timeline_card.dart';

class TimelineItem extends StatelessWidget {
  final Map<String, dynamic> duty;
  final Color color;
  final Future<String?> roleFuture; // Change from String to Future<String?>

  const TimelineItem({
    super.key,
    required this.duty,
    required this.color,
    required this.roleFuture, // Now a Future
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: roleFuture, // Pass the Future here
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // While waiting, show a loading spinner
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // Handle error case
        } else {
          final String? role = snapshot.data; // Get the resolved role

          final String? completionStatus = duty['completed'] as String?;
          final String studentName = duty['user_info'] != null
              ? "${duty['user_info']['first_name']} ${duty['user_info']['last_name']}"
              : "No Student Info"; // Handle case where student info is missing

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Container(
                  width: 60,
                  alignment: Alignment.centerRight,
                  child: Text(
                    _formatDate(duty['date'].toString()),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Manrope',
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TimelineTile(
                  alignment: TimelineAlign.manual,
                  lineXY: 0.01,
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
                    dutyTitle: duty['subject'].toString(),
                    professorName:
                        role == 'Professor' ? studentName : duty['professor'],
                    roomName: duty['room'].toString(),
                    timeInAndOut: _formatTime(duty['time'].toString()),
                    isCompleted: completionStatus == "true",
                    isNotCompleted: completionStatus == "false",
                    cardColor: Colors.white,
                  ),
                ),
              ),
            ],
          );
        }
      },
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

  String _formatTime(String time) {
    final DateTime parsedTime = DateFormat('HH:mm:ss').parse(time);
    return DateFormat('h:mm a').format(parsedTime);
  }
}
