import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TransparentButton extends StatelessWidget {
  const TransparentButton(
      {super.key, required this.onPressed, required this.buttonText});

  final VoidCallback onPressed;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Theme.of(context).brightness == Brightness.light
                ? GlobalColorsLight.alternateColor
                : GlobalColorsDark.alternateColor,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        alignment: Alignment.center,
        child: Text(
          buttonText,
          style: GoogleFonts.outfit(
            color: Theme.of(context).brightness == Brightness.light
                ? GlobalColorsLight.primaryTextColor
                : GlobalColorsDark.primaryTextColor,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
