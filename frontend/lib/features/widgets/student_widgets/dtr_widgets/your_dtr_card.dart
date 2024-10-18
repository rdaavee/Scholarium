import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class YourDtrCard extends StatelessWidget {
  final DateTime date;
  final String timeIn;
  final String timeOut;
  final String hoursRendered;
  final String remarks;

  final Color cardColor;

  const YourDtrCard({
    super.key,
    required this.date,
    required this.timeIn,
    required this.timeOut,
    required this.hoursRendered,
    required this.cardColor,
    required this.remarks,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);

    return Table(
      border: TableBorder.all(
        color: Colors.black.withOpacity(1),
        width: .3,
      ),
      columnWidths: const {
        0: FixedColumnWidth(75),
        1: FixedColumnWidth(75),
        2: FixedColumnWidth(70),
        3: FixedColumnWidth(80),
        4: FixedColumnWidth(100),
      },
      children: [
        TableRow(
          children: [
            _buildCell(formattedDate),
            _buildCell(timeIn),
            _buildCell(timeOut),
            _buildCell(hoursRendered),
            _buildCell(remarks),
          ],
        ),
      ],
    );
  }

  Widget _buildCell(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 8.7,
          ),
        ),
      ),
    );
  }
}
