import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThreeDimensionalButton extends StatelessWidget {
  const ThreeDimensionalButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    this.color = GlobalColors.primaryColor,
    this.fontSize = 20,
  });

  final VoidCallback onPressed;
  final String buttonText;
  final Color color;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: const Border(
              top: BorderSide(
                color: GlobalColors.secondaryColor,
                width: 2,
              ),
              left: BorderSide(
                color: GlobalColors.secondaryColor,
                width: 2,
              ),
              right: BorderSide(
                color: GlobalColors.secondaryColor,
                width: 2,
              ),
              bottom: BorderSide(
                color: GlobalColors.secondaryColor,
                width: 5,
              ),
            ),
          ),
          child: Text(
            buttonText,
            style: GoogleFonts.outfit(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: color == GlobalColors.primaryColor
                  ? Colors.white
                  : GlobalColors.secondaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
