import 'package:flutter/material.dart';
import 'package:isHKolarium/config/constants/colors.dart';

class PostTextField extends StatelessWidget {
  final TextEditingController controller;

  const PostTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 1,
      decoration: InputDecoration(
        hintText: 'Create a post',
        labelStyle: const TextStyle(
          color: Colors.grey,
          fontFamily: 'Manrope',
          fontSize: 13,
        ),
        floatingLabelStyle: const TextStyle(
          fontFamily: 'Manrope',
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: ColorPalette.primary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: ColorPalette.primary,
            width: 2,
          ),
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
        fontFamily: 'Manrope',
        fontWeight: FontWeight.w100,
      ),
    );
  }
}
