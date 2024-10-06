import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddTopicTextFormField extends StatelessWidget {
  const AddTopicTextFormField({
    super.key,
    required this.textEditingController,
    required this.labelText,
    this.icon,
    this.onIconTap,
    this.maxLines = 1,
    this.minLines = 1,
    this.keyboardType = TextInputType.text,
  });

  final TextEditingController textEditingController;
  final String labelText;
  final IconData? icon;
  final VoidCallback? onIconTap;
  final int maxLines;
  final int minLines;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(12.0),
      child: TextFormField(
        maxLines: maxLines,
        minLines: minLines,
        onTapOutside: (e) {
          FocusScope.of(context).unfocus();
        },
        keyboardType: keyboardType,
        controller: textEditingController,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(20),
          labelText: labelText,
          labelStyle: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          suffixIcon: icon != null
              ? IconButton(
                  icon: Icon(icon),
                  onPressed: onIconTap,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
        ),
        style: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
