import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'timeline_card.dart';

class TimelineItem extends StatelessWidget {
  final Map<String, String> duty;
  final bool isCompleted;
  final Color color;

  TimelineItem({
    required this.duty,
    required this.isCompleted,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 75,
          alignment: Alignment.centerRight,
          child: Text(
            duty['date']!,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              color: Colors.grey[600],
            ),
          ),
        ),
        Expanded(
          child: TimelineTile(
            alignment: TimelineAlign.manual,
            lineXY: 0.1,
            indicatorStyle: IndicatorStyle(
              width: 20,
              color: isCompleted ? Colors.green : color,
              iconStyle: IconStyle(
                iconData:
                    isCompleted ? Icons.check : Icons.radio_button_unchecked,
                color: Colors.white,
              ),
            ),
            afterLineStyle: LineStyle(
              color: Colors.grey,
              thickness: 1.0,
            ),
            beforeLineStyle: LineStyle(
              color: Colors.grey,
              thickness: 1.0,
            ),
            endChild: TimelineCard(
              dutyTitle: duty['dutyTitle']!,
              professorName: duty['professorName']!,
              roomName: duty['roomName']!,
              timeInAndOut: duty['timeInAndOut']!,
              isCompleted: isCompleted,
              cardColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
