import 'package:flutter/material.dart';

class ScheduleDropdown extends StatelessWidget {
  final String selectedMonth;
  final List<String> months;
  final ValueChanged<String?> onChanged;

  const ScheduleDropdown({
    super.key,
    required this.selectedMonth,
    required this.months,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedMonth,
      padding: const EdgeInsets.only(right: 16.0),
      icon: const Icon(Icons.arrow_downward),
      style: const TextStyle(
        color: Colors.black,
        fontFamily: 'Manrope',
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      decoration: const InputDecoration(
        border: InputBorder.none,
      ),
      onChanged: onChanged,
      isExpanded: true,
      items: months.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(value),
          ),
        );
      }).toList(),
    );
  }
}
