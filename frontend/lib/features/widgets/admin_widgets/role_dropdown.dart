import 'package:flutter/material.dart';

class RoleDropdown extends StatelessWidget {
  final String? selectedRole;
  final ValueChanged<String?> onChanged;

  const RoleDropdown({
    Key? key,
    required this.selectedRole,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> roles = [
      'All Users',
      'Student',
      'Professor',
      'Admin',
    ];

    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Select Role',
        border: OutlineInputBorder(),
      ),
      value: selectedRole,
      items: roles.map((String role) {
        return DropdownMenuItem<String>(
          value: role,
          child: Text(role),
        );
      }).toList(),
      onChanged: onChanged,
      hint: const Text('Select Role'),
    );
  }
}
