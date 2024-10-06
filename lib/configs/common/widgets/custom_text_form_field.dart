import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.textEditingController,
    required this.labelText,
    this.isPassword = false,
    this.icon,
    this.onIconTap,
    this.readOnly = false,
    this.onReadOnlyTap,
    this.isDigitsOnly = false,
  });

  final TextEditingController textEditingController;
  final String labelText;
  final bool isPassword;
  final IconData? icon;
  final VoidCallback? onIconTap;
  final bool readOnly;
  final VoidCallback? onReadOnlyTap;
  final bool isDigitsOnly;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      onTap: readOnly ? onReadOnlyTap : null,
      controller: textEditingController,
      keyboardType: isDigitsOnly ? TextInputType.number : TextInputType.text,
      inputFormatters: [
        if (isDigitsOnly) FilteringTextInputFormatter.digitsOnly,
      ],
      obscureText: isPassword,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: GoogleFonts.outfit(
          fontWeight: FontWeight.w500,
          fontSize: 14.0,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: ColorUtils.getAlternateColor(context),
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: GlobalColors.primaryColor,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        filled: true,
        fillColor: ColorUtils.getSecondaryBackgroundColor(context),
        contentPadding: const EdgeInsets.all(24.0),
        suffixIcon: icon != null
            ? InkWell(
                onTap: onIconTap,
                child: Icon(
                  icon,
                  color: ColorUtils.getPrimaryTextColor(context),
                  size: 16,
                ),
              )
            : null,
      ),
      style: GoogleFonts.outfit(
        fontWeight: FontWeight.w500,
        fontSize: 14.0,
      ),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return '${'please_enter'.tr} $labelText';
        }
        return null;
      },
    );
  }
}
