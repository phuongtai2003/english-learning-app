import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TypingTextFormField extends StatelessWidget {
  const TypingTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.suffixIcon,
    required this.onFieldSubmitted,
  });
  final TextEditingController controller;
  final String labelText;
  final Widget? suffixIcon;
  final Function(String) onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      onFieldSubmitted: onFieldSubmitted,
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: GoogleFonts.outfit(
          fontWeight: FontWeight.w500,
          fontSize: 14.0,
        ),
        border: null,
        filled: true,
        fillColor: ColorUtils.getSecondaryBackgroundColor(context),
        contentPadding: const EdgeInsets.all(24.0),
        suffixIcon: suffixIcon,
      ),
      style: GoogleFonts.outfit(
        fontWeight: FontWeight.w500,
        fontSize: 14.0,
      ),
    );
  }
}
