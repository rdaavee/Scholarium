import 'package:flutter/material.dart';
import 'package:isHKolarium/config/constants/colors.dart';

class CustomOTPTextField extends StatelessWidget {
  final TextEditingController controller;
  final int index;
  final int maxLength;
  final void Function(String)? onChanged;

  const CustomOTPTextField({
    super.key,
    required this.controller,
    required this.index,
    this.maxLength = 1,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: '',
        counterStyle: const TextStyle(
          color: Colors.white,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: ColorPalette.primary,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
      maxLength: maxLength,
      onChanged: (value) {
        if (onChanged != null) {
          onChanged!(value);
        }
        if (value.length == 1 && index < 5) {
          FocusScope.of(context).nextFocus();
        } else if (value.isEmpty && index > 0) {
          FocusScope.of(context).previousFocus();
        }
      },
    );
  }
}
