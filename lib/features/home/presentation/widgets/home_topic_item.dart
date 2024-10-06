import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:final_flashcard/features/topic/domain/entities/topic.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeTopicItem extends StatelessWidget {
  const HomeTopicItem({
    super.key,
    required this.onTap,
    required this.topic,
  });
  final Topic topic;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: GlobalColors.primaryColor.withOpacity(0.2),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      topic.title ?? '',
                      overflow: TextOverflow.visible,
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        color: ColorUtils.getPrimaryTextColor(context),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(
                6,
              ),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      "${topic.vocabularies?.length ?? 0} ${'vocabularies'.tr}",
                      overflow: TextOverflow.visible,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: ColorUtils.getSecondaryTextColor(
                          context,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(
                6,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        topic.user?.image ?? '',
                      ),
                    ),
                  ),
                  const Gap(
                    16,
                  ),
                  Flexible(
                    child: Text(
                      topic.user?.name ?? '',
                      overflow: TextOverflow.visible,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: ColorUtils.getPrimaryTextColor(
                          context,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
