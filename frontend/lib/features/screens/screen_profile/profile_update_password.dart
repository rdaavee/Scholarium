import 'package:flutter/material.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class ProfileChangePassword extends StatelessWidget {
  final VoidCallback onPasswordChanged;

  const ProfileChangePassword({super.key, required this.onPasswordChanged});

  @override
  Widget build(BuildContext context) {
    final globalService = GlobalRepositoryImpl();
    final formKey = GlobalKey<FormState>();
    final TextEditingController oldPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPalette.primary,
        title: const Text(
          'Change Password',
          style: TextStyle(
            color: ColorPalette.accentWhite,
            letterSpacing: 0.5,
            fontSize: 15,
          ),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: ColorPalette.accentWhite,
            size: 13.0,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color(0xFFF0F3F4),
      body: SingleChildScrollView(
        child: Container(
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
                _buildPasswordField(
                    oldPasswordController, 'Please enter your old password'),
                const SizedBox(height: 16),
                _buildPasswordField(
                    newPasswordController, 'Please enter your new password'),
                const SizedBox(height: 16),
                _buildPasswordField(
                    confirmPasswordController, 'Confirm new password',
                    isConfirm: true),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorPalette.btnColor,
                    minimumSize: const Size(360, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                  ),
                  child: const Text(
                    'Change Password',
                    style: TextStyle(
                      color: Colors.white,
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
                          _showSnackBar(
                              context,
                              'Success',
                              'Password updated successfully',
                              ContentType.success);
                          onPasswordChanged();
                          Navigator.of(context).pop();
                        } else {
                          _showSnackBar(context, 'Error', 'Invalid Credentials',
                              ContentType.failure);
                        }
                      } catch (e) {
                        print('Failed to update password: $e');
                        _showSnackBar(context, 'Error', 'Invalid Credentials',
                            ContentType.failure);
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

  Widget _buildPasswordField(TextEditingController controller, String hint,
      {bool isConfirm = false}) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        hintText: hint,
        labelStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 13,
        ),
        floatingLabelStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: ColorPalette.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: ColorPalette.primary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        hoverColor: ColorPalette.primary,
      ),
      style: const TextStyle(
        color: Colors.black,
        fontSize: 12.0,
        fontWeight: FontWeight.w100,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return isConfirm ? 'Please confirm your new password' : '${hint}';
        }
        return null;
      },
    );
  }

  void _showSnackBar(BuildContext context, String title, String message,
      ContentType contentType) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: contentType,
      ),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
