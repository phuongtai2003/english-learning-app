import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({
    super.key,
    required this.onTap,
  });
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: GlobalColors.primaryColor.withOpacity(0.2),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 16,
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: GlobalColors.primaryColor),
              const Gap(8),
              Text(
                'search_study_sets'.tr,
                style: GoogleFonts.outfit(
                  color: GlobalColors.primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
