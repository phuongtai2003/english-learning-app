import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:final_flashcard/configs/common/widgets/three_dimensional_button.dart';
import 'package:final_flashcard/features/learning/domain/entities/topic_learning_statistics.dart';
import 'package:final_flashcard/features/learning/domain/entities/vocabulary_statistics.dart';
import 'package:final_flashcard/features/topic/domain/entities/topic.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LibraryTopicItem extends StatefulWidget {
  const LibraryTopicItem({
    super.key,
    required this.onTap,
    required this.topic,
    required this.onEditPressed,
    this.isSelected = false,
    this.allowedToEdit = false,
    this.topicLearningStatistics,
    this.vocabularyStatistics,
  });
  final Topic topic;
  final TopicLearningStatistics? topicLearningStatistics;
  final List<VocabularyStatistics>? vocabularyStatistics;
  final VoidCallback onTap;
  final bool? isSelected;
  final VoidCallback onEditPressed;
  final bool allowedToEdit;

  @override
  State<LibraryTopicItem> createState() => _LibraryTopicItemState();
}

class _LibraryTopicItemState extends State<LibraryTopicItem>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool _isExpanded = false;

  void _toggleHeight() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Material(
      color: GlobalColors.primaryColor.withOpacity(0.2),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: widget.isSelected == true
                  ? GlobalColors.goldColor
                  : Colors.transparent,
              width: 1,
            ),
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: widget.topic.image != null
                          ? CachedNetworkImage(
                              imageUrl: widget.topic.image!,
                              fit: BoxFit.fill,
                              alignment: Alignment.center,
                            )
                          : Image.asset(
                              'assets/images/app_icon.png',
                              fit: BoxFit.fill,
                              alignment: Alignment.center,
                            ),
                    ),
                  ),
                  const Gap(18),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.topic.title ?? '',
                              style: GoogleFonts.outfit(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: ColorUtils.getPrimaryTextColor(context),
                              ),
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(50),
                              onTap: _toggleHeight,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Icon(
                                  _isExpanded
                                      ? Icons.keyboard_arrow_up_rounded
                                      : Icons.keyboard_arrow_down_rounded,
                                  color:
                                      ColorUtils.getPrimaryTextColor(context),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(10),
                        Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.clock,
                              size: 20,
                              color: ColorUtils.getSecondaryTextColor(context),
                            ),
                            const Gap(5),
                            Flexible(
                              child: Text(
                                widget.topicLearningStatistics != null
                                    ? '${'last_reviewed'.tr} ${getAgoTime(widget.topicLearningStatistics!.updatedAt!)}'
                                    : "${'created_on'.tr} ${widget.topic.createdAt?.toLocal().toString().split(' ')[0] ?? ''}",
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  color:
                                      ColorUtils.getSecondaryTextColor(context),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(16),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: GlobalColors.orangeColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  widget.topicLearningStatistics != null
                                      ? "${widget.vocabularyStatistics?.where((element) => (element.correctCount ?? 0) - (element.incorrectCount ?? 0) <= 10).length ?? 0} ${'not_learned'.tr}"
                                      : '${widget.topic.vocabularies?.length} ${'not_learned'.tr}',
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.outfit(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const Gap(10),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: GlobalColors.blueColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  widget.topicLearningStatistics != null
                                      ? "${widget.vocabularyStatistics?.where((element) => (element.correctCount ?? 0) - (element.incorrectCount ?? 0) <= 20 && (element.correctCount ?? 0) - (element.incorrectCount ?? 0) > 10).length ?? 0} ${'learned'.tr}"
                                      : '0 ${'learned'.tr}',
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.outfit(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const Gap(10),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: GlobalColors.secondaryColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  widget.topicLearningStatistics != null
                                      ? "${widget.vocabularyStatistics?.where((element) => (element.correctCount ?? 0) - (element.incorrectCount ?? 0) > 20).length ?? 0} ${'mastered'.tr}"
                                      : '0 ${'mastered'.tr}',
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.outfit(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Container(
                  constraints: !_isExpanded
                      ? const BoxConstraints(maxHeight: 0.0)
                      : const BoxConstraints(maxHeight: double.infinity),
                  child: !_isExpanded
                      ? const SizedBox()
                      : Column(
                          children: [
                            const Gap(10),
                            Divider(
                              height: 10,
                              thickness: 2,
                              color: ColorUtils.getPrimaryTextColor(context),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'not_learned'.tr,
                                  style: GoogleFonts.outfit(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: ColorUtils.getPrimaryTextColor(
                                      context,
                                    ),
                                  ),
                                ),
                                Text(
                                  widget.topicLearningStatistics != null
                                      ? "${widget.vocabularyStatistics?.where((element) => (element.correctCount ?? 0) - (element.incorrectCount ?? 0) <= 10).length ?? 0} ${'vocabularies'.tr}"
                                      : '${widget.topic.vocabularies?.length} ${'vocabularies'.tr}',
                                  style: GoogleFonts.outfit(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'learned'.tr,
                                  style: GoogleFonts.outfit(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: ColorUtils.getPrimaryTextColor(
                                      context,
                                    ),
                                  ),
                                ),
                                Text(
                                  widget.topicLearningStatistics != null
                                      ? "${widget.vocabularyStatistics?.where((element) => (element.correctCount ?? 0) - (element.incorrectCount ?? 0) <= 20 && (element.correctCount ?? 0) - (element.incorrectCount ?? 0) > 10).length ?? 0} ${'vocabularies'.tr}"
                                      : '0 ${'vocabularies'.tr}',
                                  style: GoogleFonts.outfit(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'mastered'.tr,
                                  style: GoogleFonts.outfit(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: ColorUtils.getPrimaryTextColor(
                                      context,
                                    ),
                                  ),
                                ),
                                Text(
                                  widget.topicLearningStatistics != null
                                      ? "${widget.vocabularyStatistics?.where((element) => (element.correctCount ?? 0) - (element.incorrectCount ?? 0) > 20).length ?? 0} ${'vocabularies'.tr}"
                                      : '0 ${'vocabularies'.tr}',
                                  style: GoogleFonts.outfit(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              height: 10,
                              thickness: 2,
                              color: ColorUtils.getPrimaryTextColor(context),
                            ),
                            const Gap(10),
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      widget.onTap();
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.eye,
                                          color: ColorUtils.getPrimaryTextColor(
                                              context),
                                        ),
                                        const Gap(10),
                                        Text(
                                          'view'.tr,
                                          style: GoogleFonts.outfit(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                ColorUtils.getPrimaryTextColor(
                                              context,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (widget.allowedToEdit)
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: widget.onEditPressed,
                                      child: Row(
                                        children: [
                                          Icon(
                                            FontAwesomeIcons.penToSquare,
                                            color:
                                                ColorUtils.getPrimaryTextColor(
                                              context,
                                            ),
                                          ),
                                          const Gap(10),
                                          Text(
                                            'edit'.tr,
                                            style: GoogleFonts.outfit(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              color: ColorUtils
                                                  .getPrimaryTextColor(
                                                context,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                Expanded(
                                  child: ThreeDimensionalButton(
                                    onPressed: () => widget.onTap(),
                                    buttonText: 'learn'.tr,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getAgoTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    if (difference.inDays > 0) {
      return '${difference.inDays} ${'days_ago'.tr}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${'hours_ago'.tr}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${'minutes_ago'.tr}';
    } else {
      return 'just_now'.tr;
    }
  }
}
