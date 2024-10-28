import 'package:flutter/material.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/config/assets/app_images.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class ProfileChangePassword extends StatefulWidget {
  final VoidCallback onPasswordChanged;

  const ProfileChangePassword({super.key, required this.onPasswordChanged});

  @override
  State<ProfileChangePassword> createState() => _ProfileChangePasswordState();
}

class _ProfileChangePasswordState extends State<ProfileChangePassword> {
  final globalService = GlobalRepositoryImpl();
  final formKey = GlobalKey<FormState>();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  String? errorMessage;
  bool isOldPasswordVisible = false;
  bool isNewPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
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
                  AppImages.changePasswordImg,
                  width: 250,
                  height: 250,
                ),
                const SizedBox(height: 16),
                _buildPasswordField(
                  oldPasswordController,
                  'Please enter your old password',
                  isPassword: true,
                  isPasswordVisible: isOldPasswordVisible,
                  togglePasswordVisibility: () {
                    setState(() {
                      isOldPasswordVisible = !isOldPasswordVisible;
                    });
                  },
                ),
                const SizedBox(height: 16),
                _buildPasswordField(
                  newPasswordController,
                  'Please enter your new password',
                  isPassword: true,
                  isPasswordVisible: isNewPasswordVisible,
                  togglePasswordVisibility: () {
                    setState(() {
                      isNewPasswordVisible = !isNewPasswordVisible;
                    });
                  },
                ),
                const SizedBox(height: 16),
                _buildPasswordField(
                  confirmPasswordController,
                  'Confirm new password',
                  isPassword: true,
                  isPasswordVisible: isConfirmPasswordVisible,
                  togglePasswordVisibility: () {
                    setState(() {
                      isConfirmPasswordVisible = !isConfirmPasswordVisible;
                    });
                  },
                  isConfirm: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorPalette.btnColor,
                    minimumSize: const Size(360, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                          widget.onPasswordChanged();
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

  Widget _buildPasswordField(
    TextEditingController controller,
    String hint, {
    required bool isPassword,
    required bool isPasswordVisible,
    required VoidCallback togglePasswordVisibility,
    bool isConfirm = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          obscureText: isPassword && !isPasswordVisible,
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
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: togglePasswordVisibility,
                  )
                : null,
          ),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12.0,
            fontWeight: FontWeight.w100,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return isConfirm ? 'Please confirm your new password' : hint;
            }
            if (isPassword) {
              validatePassword(value);
              if (errorMessage != null) {
                return errorMessage;
              }
            }
            if (isConfirm && value != newPasswordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
      ],
    );
  }

  void validatePassword(String value) {
    setState(() {
      if (value.isEmpty) {
        errorMessage = null;
      } else if (value.length < 8) {
        errorMessage = 'Password must be longer than 8 characters.';
      } else if (!value.contains(RegExp(r'[A-Z]'))) {
        errorMessage = 'Uppercase letter is missing.';
      } else if (!value.contains(RegExp(r'[a-z]'))) {
        errorMessage = 'Lowercase letter is missing.';
      } else if (!value.contains(RegExp(r'[0-9]'))) {
        errorMessage = 'Digit is missing.';
      } else if (!value.contains(RegExp(r'[!@#%^&*(),.?":{}|<>]'))) {
        errorMessage = 'Special character is missing.';
      } else {
        errorMessage = null;
      }
    });
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
