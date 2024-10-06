import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class OtpInputTextField extends StatelessWidget {
  const OtpInputTextField(
      {super.key, required this.controller, required this.onChanged});
  final TextEditingController controller;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ColorUtils.getSecondaryBackgroundColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ColorUtils.getAlternateColor(context),
          width: 2,
        ),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        onChanged: onChanged,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        textAlign: TextAlign.center,
        style: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: ColorUtils.getPrimaryTextColor(context),
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '0',
          hintStyle: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: ColorUtils.getPrimaryTextColor(context).withOpacity(0.4),
          ),
        ),
      ),
    );
  }
}
