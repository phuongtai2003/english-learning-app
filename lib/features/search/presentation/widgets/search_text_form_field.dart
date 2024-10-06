import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchTextFormField extends StatelessWidget {
  const SearchTextFormField({
    super.key,
    required this.textEditingController,
    required this.hint,
  });
  final TextEditingController textEditingController;
  final String hint;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: GlobalColors.primaryColor,
      ),
      onTapOutside: (e) {
        FocusScope.of(context).unfocus();
      },
      textAlignVertical: TextAlignVertical.center,
      textInputAction: TextInputAction.search,
      controller: textEditingController,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(16),
        prefixIcon: const Icon(
          Icons.search,
          color: GlobalColors.primaryColor,
          size: 26,
        ),
        filled: true,
        fillColor: GlobalColors.primaryColor.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        hintText: hint,
        hintStyle: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: GlobalColors.primaryColor.withOpacity(0.5),
        ),
      ),
    );
  }
}
