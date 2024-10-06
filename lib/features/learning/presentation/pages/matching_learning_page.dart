import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:final_flashcard/configs/common/widgets/touchable_opacity.dart';
import 'package:final_flashcard/configs/routes/route_generator.dart';
import 'package:final_flashcard/core/data/enums.dart';
import 'package:final_flashcard/core/utils/ui_helpers.dart';
import 'package:final_flashcard/features/learning/presentation/bloc/matching_learning_bloc/matching_learning_bloc.dart';
import 'package:final_flashcard/features/learning/presentation/widgets/matching_card_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MatchingLearningPage extends StatefulWidget {
  const MatchingLearningPage({super.key});

  @override
  State<MatchingLearningPage> createState() => _MatchingLearningPageState();
}

class _MatchingLearningPageState extends State<MatchingLearningPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
  }

  initTimer() async {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        context.read<MatchingLearningBloc>().add(const IncreaseTimerEvent());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 200,
        leading: BlocBuilder<MatchingLearningBloc, MatchingLearningState>(
          builder: (_, state) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: GlobalColors.primaryColor,
                  ),
                  onPressed: () {
                    if (_timer != null) {
                      _timer?.cancel();
                    }
                    navigator?.pop();
                  },
                ),
                const Gap(16),
                if (state is MatchingLearningLoaded ||
                    state is MatchingLearningCorrectAnswer ||
                    state is MatchingLearningWrongAnswer) ...[
                  Expanded(
                    child: Text(
                      '${state.data.seconds} ${'seconds'.tr}',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        color: GlobalColors.primaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ] else ...[
                  Text(
                    'match'.tr,
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      color: GlobalColors.primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              ],
            );
          },
        ),
        title: BlocBuilder<MatchingLearningBloc, MatchingLearningState>(
          builder: (_, state) {
            final currentPageIndex = state.data.currentPageIndex;
            final totalPage = state.data.totalPage;
            if (state is MatchingLearningLoaded ||
                state is MatchingLearningCorrectAnswer ||
                state is MatchingLearningWrongAnswer ||
                state is MatchingLearningFinished) {
              return Text(
                '${currentPageIndex + 1}/$totalPage',
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  color: GlobalColors.primaryColor,
                  fontWeight: FontWeight.w700,
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext cntext) {
    return SafeArea(
      child: BlocConsumer<MatchingLearningBloc, MatchingLearningState>(
        listener: (_, state) {
          if (state is MatchingLearningWrongAnswer) {
            UIHelpers.showSnackBar(
              context,
              'wrong_answer'.tr,
              SnackBarType.error,
            );
          } else if (state is MatchingLearningFinished) {
            _timer?.cancel();
            context
                .read<MatchingLearningBloc>()
                .add(const UpdateLearningStatistic());
          } else if (state is MatchingLearningError) {
            UIHelpers.showAwesomeDialog(
              context: cntext,
              title: 'error'.tr,
              message: state.data.error.tr,
              type: DialogType.error,
            );
          }
        },
        builder: (_, state) {
          if (state is MatchingLearningLoaded ||
              state is MatchingLearningCorrectAnswer ||
              state is MatchingLearningWrongAnswer) {
            return _buildMatchingCards(cntext, state);
          } else if (state is MatchingLearningFinished) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is MatchingLearningUpdatedLearningStatistic) {
            return _buildFinished(cntext, state);
          }
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${'ready_to_start'.tr} ?",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 28,
                    color: ColorUtils.getPrimaryTextColor(cntext),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Gap(8),
                Text(
                  'matching_desc'.tr,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    color: ColorUtils.getPrimaryTextColor(cntext),
                  ),
                ),
                const Gap(16),
                TouchableOpacity(
                  color: GlobalColors.primaryColor,
                  onPressed: () {
                    initTimer();
                    cntext.read<MatchingLearningBloc>().add(
                          const StartMatchingEvent(),
                        );
                  },
                  child: Text(
                    'start'.tr,
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMatchingCards(BuildContext cntext, MatchingLearningState state) {
    final matchingCards = state.data.matchingCards;
    final currentPageIndex = state.data.currentPageIndex;
    final int itemCount =
        (matchingCards.length - currentPageIndex * 12).clamp(0, 12);
    final int row1Count = itemCount >= 3 ? 3 : itemCount;
    final int row2Count = itemCount - row1Count > 3 ? 3 : itemCount - row1Count;
    final int row3Count = itemCount - row1Count - row2Count > 3
        ? 3
        : itemCount - row1Count - row2Count;
    final int row4Count = itemCount - row1Count - row2Count - row3Count > 3
        ? 3
        : itemCount - row1Count - row2Count - row3Count;
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        if (row1Count > 0)
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  for (int i = 0; i < row1Count; i++)
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        child: MatchingCardItem(
                          content:
                              matchingCards[currentPageIndex * 12 + i].text ??
                                  '',
                          isAnsweredCorrectly:
                              matchingCards[currentPageIndex * 12 + i]
                                      .isAnsweredCorrectly ??
                                  false,
                          isSelected: matchingCards[currentPageIndex * 12 + i]
                                  .isSelected ??
                              false,
                          onTap: () {
                            cntext.read<MatchingLearningBloc>().add(
                                  SelectMatchingCard(
                                    index: currentPageIndex * 12 + i,
                                  ),
                                );
                          },
                        ),
                      ),
                    ),
                  for (int i = 0; i < 3 - row1Count; i++) const Spacer(),
                ],
              ),
            ),
          )
        else
          const Spacer(),
        if (row2Count > 0)
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  for (int i = 0; i < row2Count; i++)
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: MatchingCardItem(
                          content: matchingCards[currentPageIndex * 12 + 3 + i]
                                  .text ??
                              '',
                          isAnsweredCorrectly:
                              matchingCards[currentPageIndex * 12 + 3 + i]
                                      .isAnsweredCorrectly ??
                                  false,
                          isSelected:
                              matchingCards[currentPageIndex * 12 + 3 + i]
                                      .isSelected ??
                                  false,
                          onTap: () {
                            cntext.read<MatchingLearningBloc>().add(
                                  SelectMatchingCard(
                                    index: currentPageIndex * 12 + 3 + i,
                                  ),
                                );
                          },
                        ),
                      ),
                    ),
                  for (int i = 0; i < 3 - row2Count; i++) const Spacer(),
                ],
              ),
            ),
          )
        else
          const Spacer(),
        if (row3Count > 0)
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  for (int i = 0; i < row3Count; i++)
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: MatchingCardItem(
                          content: matchingCards[currentPageIndex * 12 + 6 + i]
                                  .text ??
                              '',
                          isAnsweredCorrectly:
                              matchingCards[currentPageIndex * 12 + 6 + i]
                                      .isAnsweredCorrectly ??
                                  false,
                          isSelected:
                              matchingCards[currentPageIndex * 12 + 6 + i]
                                      .isSelected ??
                                  false,
                          onTap: () {
                            cntext.read<MatchingLearningBloc>().add(
                                  SelectMatchingCard(
                                    index: currentPageIndex * 12 + 6 + i,
                                  ),
                                );
                          },
                        ),
                      ),
                    ),
                  for (int i = 0; i < 3 - row3Count; i++) const Spacer(),
                ],
              ),
            ),
          )
        else
          const Spacer(),
        if (row4Count > 0)
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  for (int i = 0; i < row4Count; i++)
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: MatchingCardItem(
                          content: matchingCards[currentPageIndex * 12 + 9 + i]
                                  .text ??
                              '',
                          isAnsweredCorrectly:
                              matchingCards[currentPageIndex * 12 + 9 + i]
                                      .isAnsweredCorrectly ??
                                  false,
                          isSelected:
                              matchingCards[currentPageIndex * 12 + 9 + i]
                                      .isSelected ??
                                  false,
                          onTap: () {
                            cntext.read<MatchingLearningBloc>().add(
                                  SelectMatchingCard(
                                    index: currentPageIndex * 12 + 9 + i,
                                  ),
                                );
                          },
                        ),
                      ),
                    ),
                  for (int i = 0; i < 3 - row4Count; i++) const Spacer(),
                ],
              ),
            ),
          )
        else
          const Spacer(),
      ],
    );
  }

  Widget _buildFinished(BuildContext cntext, MatchingLearningState state) {
    final topic = state.data.topic;
    final vocabularies = state.data.vocabularies;
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Gap(20),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle_outline_rounded,
                    color: GlobalColors.primaryColor,
                    size: 100,
                  ),
                  const Gap(10),
                  Text(
                    'congratulations'.tr,
                    style: GoogleFonts.outfit(
                      fontSize: 28,
                      color: GlobalColors.primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Gap(10),
                  Text(
                    'you_have_finished_matching'.tr,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      color: GlobalColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TouchableOpacity(
              color: GlobalColors.primaryColor,
              onPressed: () {
                navigator?.pop();
              },
              child: Text(
                'back'.tr,
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const Gap(10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TouchableOpacity(
              color: GlobalColors.primaryColor,
              onPressed: () {
                navigator?.popAndPushNamed(
                  RouteGenerator.learningFlashcard,
                  arguments: {
                    'TOPIC': topic,
                    'VOCABULARIES': vocabularies,
                  },
                );
              },
              child: Text(
                'review_flashcard'.tr,
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const Gap(10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TouchableOpacity(
              color: GlobalColors.primaryColor,
              onPressed: () {
                cntext.read<MatchingLearningBloc>().add(
                      InitMatchingLearning(
                        topic: state.data.topic!,
                        selectedVocabularies: state.data.vocabularies,
                      ),
                    );
              },
              child: Text(
                'restart'.tr,
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const Gap(20),
        ],
      ),
    );
  }
}
