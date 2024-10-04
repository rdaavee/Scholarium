import 'package:flutter/material.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/config/constants/colors.dart';

class ProfileChangePassword extends StatelessWidget {
  final VoidCallback onPasswordChanged;

  const ProfileChangePassword({super.key, required this.onPasswordChanged});

  @override
  Widget build(BuildContext context) {
    final globalService = GlobalRepositoryImpl();
    final formKey = GlobalKey<FormState>();
    final TextEditingController oldPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Change Password',
          style: TextStyle(
            fontFamily: 'Manrope',
            color: Colors.black,
            letterSpacing: 0.5,
            fontSize: 15,
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF0F3F4),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/change-pass-img.png',
                  width: 250,
                  height: 250,
                ),
                const SizedBox(height: 16),
                _buildPasswordField(oldPasswordController, 'Please enter your old password'),
                const SizedBox(height: 16),
                _buildPasswordField(newPasswordController, 'Please enter your new password'),
                const SizedBox(height: 16),
                _buildPasswordField(confirmPasswordController, 'Confirm new password', isConfirm: true),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorPalette.btnColor,
                    minimumSize: const Size(287, 55),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  child: const Text(
                    'Change Password',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      try {
                        final updateResult = await globalService.updatePassword(
                          oldPassword: oldPasswordController.text,
                          newPassword: newPasswordController.text,
                        );

                        if (updateResult.success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Password updated successfully')),
                          );
                          onPasswordChanged();
                          Navigator.of(context).pop();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Invalid Credentials')),
                          );
                        }
                      } catch (e) {
                        print('Failed to update password: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Invalid Credentials')),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );  
  }
  
  Widget _buildPasswordField(TextEditingController controller, String hint, {bool isConfirm = false}) {
      return TextFormField(
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 12.0),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.black.withOpacity(0.1)),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.black.withOpacity(0.1)),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.black.withOpacity(0.1)),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 12.0,
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w100,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return isConfirm ? 'Please confirm your new password' : 'Please enter your ${hint.toLowerCase()}';
          }
          return null;
        },
      );
    }
}
