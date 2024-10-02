import 'package:flutter/material.dart';

class StatusDropdown extends StatelessWidget {
  final String statusFilter;
  final ValueChanged<String?> onChanged;

  const StatusDropdown({
    Key? key,
    required this.statusFilter,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> statuses = ['Any', 'Active', 'Inactive'];

    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Select Status',
        border: OutlineInputBorder(),
      ),
      value: statusFilter,
      items: statuses.map((String status) {
        return DropdownMenuItem<String>(
          value: status,
          child: Text(status),
        );
      }).toList(),
      onChanged: onChanged,
      hint: const Text('Select Status'),
    );
  }
}
