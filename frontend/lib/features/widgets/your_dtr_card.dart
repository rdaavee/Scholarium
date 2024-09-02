import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class YourDtrCard extends StatelessWidget {
  final DateTime date;
  final String timeIn;
  final String timeOut;
  final String hoursToRendered;
  final String hoursRendered;
  final String teacher;
  final String teacherSignature;
  final Color cardColor;

  const YourDtrCard({
    super.key,
    required this.date,
    required this.timeIn,
    required this.timeOut,
    required this.hoursToRendered,
    required this.hoursRendered,
    required this.teacher,
    required this.teacherSignature,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);

    return Container(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Table(
          border: TableBorder.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
          columnWidths: {
            0: FixedColumnWidth(100),
            1: FixedColumnWidth(100),
            2: FixedColumnWidth(100),
            3: FixedColumnWidth(120),
            4: FixedColumnWidth(120),
            5: FixedColumnWidth(100),
            6: FixedColumnWidth(150),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              children: [
                _buildHeader('Date'),
                _buildHeader('Time In'),
                _buildHeader('Time Out'),
                _buildHeader('Hours Rendered'),
                _buildHeader('Hours to Render'),
                _buildHeader('Teacher'),
                _buildHeader('Teacher Signature'),
              ],
            ),
            TableRow(
              children: [
                _buildCell(formattedDate),
                _buildCell(timeIn),
                _buildCell(timeOut),
                _buildCell(hoursRendered),
                _buildCell(hoursToRendered),
                _buildCell(teacher),
                _buildCell(teacherSignature),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Inter',
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
