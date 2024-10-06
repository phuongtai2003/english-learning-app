import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeMenuItem extends StatelessWidget {
  const HomeMenuItem({
    super.key,
    required this.title,
    required this.imageAsset,
    required this.onTap,
  });

  final String title;
  final String imageAsset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      color: ColorUtils.getPrimaryBackgroundColor(
        context,
      ),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 24,
          ),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                imageAsset,
                width: 60,
                height: 60,
              ),
              const Gap(10),
              Flexible(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: ColorUtils.getPrimaryTextColor(
                      context,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
