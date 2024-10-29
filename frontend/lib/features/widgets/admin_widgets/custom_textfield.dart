import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final bool isEmail;
  final bool isPhone;
  final bool isReadOnly;
  final bool allowNumbers;
  final bool isSchoolId;
  final bool isPassword;

  const CustomTextField({
    super.key,
    required this.labelText,
    required this.controller,
    this.isEmail = false,
    this.isPhone = false,
    this.allowNumbers = true,
    this.isPassword = false,
    this.isReadOnly = false,
    this.isSchoolId = false,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  String? errorMessage;
  bool _isPasswordVisible = false;

  void validateSchoolId(String value) {
    if (value.isEmpty) {
      setState(() {
        errorMessage = null;
      });
      return;
    }

    if (widget.isSchoolId) {
      // Check if the input matches the format 00-0000-00000
      if (!RegExp(r'^\d{2}-\d{4}-\d{5}$').hasMatch(value)) {
        setState(() {
          errorMessage = 'Follow the format 00-0000-00000';
        });
      } else {
        setState(() {
          errorMessage = null; // Clear error if valid
        });
      }
    }
  }

  void validateEmail(String value) {
    if (value.isEmpty) {
      setState(() {
        errorMessage = null;
      });
      return;
    }

    if (widget.isEmail && value.contains('@gmail.com')) {
      if (!value.endsWith('up@phinmaed.com')) {
        setState(() {
          errorMessage = 'Email must end with up@phinmaed.com';
        });
      } else {
        setState(() {
          errorMessage = null;
        });
      }
    } else {
      setState(() {
        errorMessage = null;
      });
    }
  }

  void validatePhone(String value) {
    if (value.isEmpty) {
      setState(() {
        errorMessage = null;
      });
      return;
    }

    if (widget.isPhone) {
      if (!RegExp(r'^\d+$').hasMatch(value)) {
        setState(() {
          errorMessage = 'Contact should contain only digits';
        });
      } else if (value.length != 11) {
        setState(() {
          errorMessage = 'Contact should be 11 digits';
        });
      } else {
        setState(() {
          errorMessage = null;
        });
      }
    }
  }

  void validatePassword(String value) {
    if (value.isEmpty) {
      setState(() {
        errorMessage = null;
      });
      return;
    }

    if (widget.isPassword) {
      if (value.length < 8) {
        setState(() {
          errorMessage = 'Password must be longer than 8 characters.';
        });
      } else if (!value.contains(RegExp(r'[A-Z]'))) {
        setState(() {
          errorMessage = 'Uppercase letter is missing.';
        });
      } else if (!value.contains(RegExp(r'[a-z]'))) {
        setState(() {
          errorMessage = 'Lowercase letter is missing.';
        });
      } else if (!value.contains(RegExp(r'[0-9]'))) {
        setState(() {
          errorMessage = 'Digit is missing.';
        });
      } else if (!value.contains(RegExp(r'[!@#%^&*(),.?":{}|<>]'))) {
        setState(() {
          errorMessage = 'Special character is missing.';
        });
      } else {
        setState(() {
          errorMessage = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.isPassword && !_isPasswordVisible,
        readOnly: widget.isReadOnly,
        keyboardType: widget.isEmail
            ? TextInputType.emailAddress
            : widget.isPhone
                ? TextInputType.phone
                : TextInputType.text,
        inputFormatters: [
          LengthLimitingTextInputFormatter(150),
          if (!widget.allowNumbers)
            FilteringTextInputFormatter.allow(RegExp(r'[^\d]')),
          if (widget.isPhone) LengthLimitingTextInputFormatter(11),
          if (widget.isSchoolId) LengthLimitingTextInputFormatter(13),
        ],
        onChanged: (value) {
          if (widget.isEmail) {
            validateEmail(value);
          } else if (widget.isPassword) {
            validatePassword(value);
          } else if (widget.isPhone) {
            validatePhone(value);
          } else if (widget.isSchoolId) {
            validateSchoolId(value);
          }
        },
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 13,
          ),
          floatingLabelStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00A4E4),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.2),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(
              color: Color(0xFF00A4E4),
              width: 2,
            ),
          ),
          errorText: errorMessage,
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    size: 15,
                  ),
                  onPressed: () {
                    setState(
                      () {
                        _isPasswordVisible = !_isPasswordVisible;
                      },
                    );
                  },
                )
              : null,
        ),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 12.0,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}
