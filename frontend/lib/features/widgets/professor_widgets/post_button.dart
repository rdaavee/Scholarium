import 'package:flutter/material.dart';
import 'package:isHKolarium/config/constants/colors.dart';

class PostButton extends StatelessWidget {
  final VoidCallback onPressed;

  const PostButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorPalette.btnColor,
        minimumSize: const Size(395, 55),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ).copyWith(
        elevation: ButtonStyleButton.allOrNull(0.0),
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.hovered)) {
              return ColorPalette.primary;
            }
            return const Color(0xFFC1C1C1);
          },
        ),
      ),
      child: const Text(
        'Post',
        style: TextStyle(
          fontSize: 11.5,
          color: Colors.white,
        ),
      ),
    );
  }
}
