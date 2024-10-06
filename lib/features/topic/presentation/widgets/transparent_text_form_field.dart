import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TransparentTextFormField extends StatelessWidget {
  const TransparentTextFormField({
    super.key,
    required this.textEditingController,
    required this.hintText,
    this.maxLines = 1,
    this.minLines = 1,
    this.keyboardType = TextInputType.text,
  });
  final TextEditingController textEditingController;
  final String hintText;
  final int maxLines;
  final int minLines;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      maxLines: maxLines,
      minLines: minLines,
      keyboardType: keyboardType,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: ColorUtils.getPrimaryTextColor(context).withOpacity(0.5),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
      ),
      style: GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: ColorUtils.getPrimaryTextColor(context),
      ),
    );
  }
}
