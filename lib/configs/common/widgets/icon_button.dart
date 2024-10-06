import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    required this.icon,
  });

  final VoidCallback onPressed;
  final String buttonText;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorUtils.getPrimaryBackgroundColor(context),
        foregroundColor: ColorUtils.getSecondaryBackgroundColor(context),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 2,
            color: ColorUtils.getAlternateColor(context),
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        minimumSize: const Size.fromHeight(50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            icon,
            size: 25,
            color: ColorUtils.getPrimaryTextColor(context),
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            buttonText,
            style: GoogleFonts.outfit(
              color: ColorUtils.getPrimaryTextColor(context),
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
