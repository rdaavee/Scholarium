import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class YourDtrCard extends StatelessWidget {
  final DateTime date;
  final String timeIn;
  final String timeOut;
  final String hoursRendered;

  final Color cardColor;

  const YourDtrCard({
    super.key,
    required this.date,
    required this.timeIn,
    required this.timeOut,
    required this.hoursRendered,
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
          columnWidths: const {
            0: FixedColumnWidth(100),
            1: FixedColumnWidth(100),
            2: FixedColumnWidth(100),
            3: FixedColumnWidth(120),
          },
          children: [
            TableRow(
              children: [
                _buildCell(formattedDate),
                _buildCell(timeIn),
                _buildCell(timeOut),
                _buildCell(hoursRendered),
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
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'Manrope',
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
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'Manrope',
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
