import 'package:flutter/material.dart';
import 'package:isHKolarium/api/api_service/api_service.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileChangePassword extends StatelessWidget {
  final VoidCallback onPasswordChanged;
  const ProfileChangePassword({super.key, required this.onPasswordChanged});

  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiService();
    final formKey = GlobalKey<FormState>();
    final TextEditingController oldPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Change Password',
          style: TextStyle(
            fontFamily: 'Inter',
            color: Colors.black,
            letterSpacing: 0.5,
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
                TextFormField(
                  controller: oldPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Please enter your Old Password',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.0,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: Colors.black.withOpacity(0.1),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: Colors.black.withOpacity(0.1),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: Colors.black.withOpacity(0.1),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.0,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w100,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Old Password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Please enter your New Password',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.0,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: Colors.black.withOpacity(0.1),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: Colors.black.withOpacity(0.1),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: Colors.black.withOpacity(0.1),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.0,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w100,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your New Password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Confirm New Password',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.0,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: Colors.black.withOpacity(0.1),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: Colors.black.withOpacity(0.1),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: Colors.black.withOpacity(0.1),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.0,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w100,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your New Password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorPalette.primary,
                    side: BorderSide(
                      color: ColorPalette.primary,
                    ),
                    minimumSize: Size(287, 55),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  child: Text(
                    'Change Password',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      final token = prefs.getString('token').toString();

                      try {
                        final updateResult = await apiService.updatePassword(
                          token: token,
                          oldPassword: oldPasswordController.text,
                          newPassword: newPasswordController.text,
                          confirmPassword: confirmPasswordController.text,
                        );

                        if (updateResult.success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Password updated successfully')),
                          );
                          onPasswordChanged();
                          Navigator.of(context).pop();
                        } else {
                          // Show error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Failed to update password')),
                          );
                        }
                      } catch (e) {
                        print('Failed to update password: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Failed to update password')),
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
}