import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CardItem extends StatelessWidget {
  const CardItem({
    super.key,
    required this.term,
    required this.definition,
    this.imageUrl,
    required this.onTtsPressed,
    required this.isTermSpeaking,
    required this.isDefinitionSpeaking,
    required this.onTermPressed,
    required this.onDefinitionPressed,
    required this.onFavoritePressed,
    required this.quizDeficit,
    this.isFavorite = false,
  });
  final String term;
  final String definition;
  final String? imageUrl;
  final VoidCallback onTtsPressed;
  final bool isTermSpeaking;
  final bool isDefinitionSpeaking;
  final VoidCallback onTermPressed;
  final VoidCallback onDefinitionPressed;
  final VoidCallback onFavoritePressed;
  final bool isFavorite;
  final int quizDeficit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: GlobalColors.secondaryColor.withOpacity(0.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onTermPressed,
                  child: Text(
                    term,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      color: isTermSpeaking
                          ? GlobalColors.primaryColor
                          : Colors.white,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: onTtsPressed,
                    icon: Icon(
                      Icons.volume_up,
                      color: isTermSpeaking || isDefinitionSpeaking
                          ? GlobalColors.primaryColor
                          : Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: onFavoritePressed,
                    icon: Icon(
                      isFavorite ? Icons.star : Icons.star_border_rounded,
                      color: isTermSpeaking || isDefinitionSpeaking
                          ? GlobalColors.primaryColor
                          : Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Gap(4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onDefinitionPressed,
                  child: Text(
                    definition,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      color: isDefinitionSpeaking
                          ? GlobalColors.primaryColor
                          : Colors.white,
                    ),
                  ),
                ),
              ),
              const Gap(16),
              _buildLearningStatus(quizDeficit),
            ],
          ),
          if (imageUrl != null) ...[
            const Gap(8),
            Align(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: imageUrl ?? '',
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLearningStatus(int quizDeficit) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: quizDeficit < 10
              ? GlobalColors.orangeColor
              : quizDeficit < 20
                  ? GlobalColors.goldColor
                  : GlobalColors.primaryColor,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text(
        quizDeficit < 10
            ? 'not_learned'.tr
            : quizDeficit < 20
                ? 'learned'.tr
                : 'mastered'.tr,
        style: GoogleFonts.outfit(
          fontSize: 14,
          color: quizDeficit < 10
              ? GlobalColors.orangeColor
              : quizDeficit < 20
                  ? GlobalColors.goldColor
                  : GlobalColors.primaryColor,
        ),
      ),
    );
  }
}
