import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:isHKolarium/features/profile/widgets/profile_divider.dart';
import 'package:isHKolarium/api/api_service/api_service.dart';

class AccountOptions extends StatelessWidget {
  const AccountOptions({super.key, required Null Function() onLogout});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildOption(FontAwesomeIcons.lock, 'Change Password'),
        const SizedBox(height: 16),
        const DividerWidget(),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            final apiService = ApiService();
            apiService.logout(context);
          },
          child: _buildOption(FontAwesomeIcons.rightFromBracket, 'Logout'),
        ),
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
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFF3C3C3C),
            fontSize: 16.5,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            height: 0,
          ),
        ),
      ],
    );
  }
}