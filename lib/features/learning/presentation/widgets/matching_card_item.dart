import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MatchingCardItem extends StatelessWidget {
  const MatchingCardItem({
    super.key,
    required this.content,
    required this.onTap,
    required this.isAnsweredCorrectly,
    this.isSelected = false,
  });
  final String content;
  final VoidCallback onTap;
  final bool isAnsweredCorrectly;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return isAnsweredCorrectly
        ? const SizedBox.shrink()
        : Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: !isSelected
                      ? GlobalColors.secondaryColor.withOpacity(0.2)
                      : GlobalColors.secondaryColor.withOpacity(0.5),
                  border: Border.all(
                    color: GlobalColors.primaryColor,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    content,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: GlobalColors.primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
