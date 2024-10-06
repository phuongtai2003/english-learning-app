import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:final_flashcard/features/topic/domain/entities/vocabulary.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class YourAnswerCard extends StatelessWidget {
  const YourAnswerCard({
    super.key,
    this.isPromptTerm = false,
    required this.question,
    this.answer,
    this.isFindDefinition = false,
    this.isCorrect = false,
    this.answerText,
  });
  final bool isPromptTerm;
  final Vocabulary question;
  final Vocabulary? answer;
  final String? answerText;
  final bool isFindDefinition;
  final bool isCorrect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      foregroundDecoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color:
              isCorrect ? GlobalColors.primaryColor : GlobalColors.orangeColor,
          width: 1,
        ),
      ),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Column(
        children: [
          Text(
            isPromptTerm ? question.term ?? '' : question.definition ?? '',
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: ColorUtils.getPrimaryTextColor(context),
            ),
          ),
          const Gap(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Expanded(
                child: Column(
                  children: [
                    const Icon(
                      Icons.check,
                      color: GlobalColors.primaryColor,
                      size: 30,
                    ),
                    const Gap(4),
                    Text(
                      isFindDefinition
                          ? question.definition ?? ''
                          : question.term ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: GlobalColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              if (!isCorrect) ...[
                Expanded(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.close,
                        color: GlobalColors.orangeColor,
                        size: 30,
                      ),
                      const Gap(4),
                      Text(
                        answer != null
                            ? isFindDefinition
                                ? answer?.definition ?? ''
                                : answer?.term ?? ''
                            : answerText ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: GlobalColors.orangeColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ],
          ),
          const Gap(16),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: isCorrect
                  ? GlobalColors.primaryColor.withOpacity(0.1)
                  : GlobalColors.orangeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(8),
            child: Text(
              isCorrect ? 'correct_answer'.tr : 'wrong_answer'.tr,
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isCorrect
                    ? GlobalColors.primaryColor
                    : GlobalColors.orangeColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
