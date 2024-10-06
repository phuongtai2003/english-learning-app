import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:final_flashcard/core/data/typedef.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDropdownButton<T> extends StatelessWidget {
  const CustomDropdownButton({
    super.key,
    required this.itemsList,
    required this.onChanged,
    required this.value,
    this.dataMap,
  });
  final List<T> itemsList;
  final Function(T?) onChanged;
  final T? value;
  final DataMap? dataMap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: GlobalColors.primaryColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton(
        borderRadius: BorderRadius.circular(12),
        dropdownColor: ColorUtils.getSecondaryBackgroundColor(context),
        underline: const SizedBox.shrink(),
        padding: const EdgeInsets.symmetric(vertical: 6).copyWith(left: 12),
        icon: const Icon(
          Icons.arrow_drop_down,
          color: GlobalColors.primaryColor,
        ),
        iconSize: 50,
        isExpanded: true,
        items: itemsList
            .map<DropdownMenuItem<T>>(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(
                  dataMap == null ? e.toString() : dataMap![e],
                  style: GoogleFonts.outfit(
                    color: ColorUtils.getPrimaryTextColor(context),
                    fontSize: 16,
                  ),
                ),
              ),
            )
            .toList(),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
