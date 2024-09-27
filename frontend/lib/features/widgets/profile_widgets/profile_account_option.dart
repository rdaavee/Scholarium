import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:isHKolarium/features/screens/screen_profile/profile_update_password.dart';
import 'package:isHKolarium/features/widgets/profile_widgets/profile_divider.dart';

class AccountOptions extends StatelessWidget {
  final VoidCallback onProfileUpdated;
  final VoidCallback onLogout;

  const AccountOptions({
    super.key,
    required this.onProfileUpdated,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileChangePassword(
                  onPasswordChanged: onProfileUpdated,
                ),
              ),
            );
          },
          child: _buildOption(FontAwesomeIcons.lock, 'Change Password'),
        ),
        const SizedBox(height: 16),
        const DividerWidget(),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            _showLogoutConfirmation(context);
          },
          child: _buildOption(FontAwesomeIcons.rightFromBracket, 'Logout'),
        ),
        const SizedBox(height: 16),
        const DividerWidget(),
      ],
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    print('Showing logout confirmation dialog...');
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.bottomSlide,
      title: 'Confirm Logout',
      desc: 'Are you sure you want to logout?',
      btnCancel: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
        ),
        child: Text(
          'Cancel',
          style: TextStyle(fontFamily: 'Manrope', color: Colors.white),
        ),
      ),
      btnOk: ElevatedButton(
        onPressed: () {
          onLogout();
          Navigator.of(context).pop();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
        ),
        child: Text(
          'Confirm',
          style: TextStyle(fontFamily: 'Manrope', color: Colors.white),
        ),
      ),
    ).show();
  }

  Widget _buildOption(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 17,
          color: const Color(0xFF3C3C3C),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFF3C3C3C),
            fontSize: 16.5,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w700,
            height: 0,
          ),
        ),
      ],
    );
  }
}
