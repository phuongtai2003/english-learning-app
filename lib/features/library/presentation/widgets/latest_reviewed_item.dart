import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:final_flashcard/configs/common/widgets/three_dimensional_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LatestReviewedItem extends StatelessWidget {
  const LatestReviewedItem({
    super.key,
    required this.recentTopicTitle,
    required this.onPressed,
    required this.learnedTerms,
    required this.percentage,
  });
  final String recentTopicTitle;
  final VoidCallback onPressed;
  final int learnedTerms;
  final double percentage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: GlobalColors.primaryColor.withOpacity(
          0.2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recentTopicTitle,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Gap(10),
                Text(
                  '${'you_have_learned'.tr} $learnedTerms ${'terms'.tr.toLowerCase()}',
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Gap(8),
                ThreeDimensionalButton(
                  onPressed: onPressed,
                  buttonText: 'continue_txt'.tr,
                  fontSize: 20,
                ),
              ],
            ),
          ),
          const Gap(20),
          SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: RotatedBox(
                    quarterTurns: 2,
                    child: CircularProgressIndicator(
                      value: percentage,
                      strokeWidth: 5,
                      color: GlobalColors.secondaryColor,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      'reviewed'.tr,
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${(percentage * 100).toStringAsFixed(2)}%',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: GlobalColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
