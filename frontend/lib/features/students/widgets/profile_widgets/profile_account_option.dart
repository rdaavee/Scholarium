import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:isHKolarium/features/students/widgets/profile_widgets/profile_divider.dart';

class AccountOptions extends StatelessWidget {
  const AccountOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildOption(FontAwesomeIcons.lock, 'Change Password'),
        const SizedBox(height: 16),
        const DividerWidget(),
        const SizedBox(height: 20),
        _buildOption(FontAwesomeIcons.rightFromBracket, 'Logout'),
        const SizedBox(height: 16),
        const DividerWidget(),
      ],
    );
  }

  Widget _buildOption(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 17,
          color: Color(0xFF3C3C3C),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          child: Text(
            text,
            style: TextStyle(
              color: Color(0xFF3C3C3C),
              fontSize: 16.5,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              height: 0,
            ),
          ),
        ),
      ],
    );
  }
}
