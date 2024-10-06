import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:final_flashcard/configs/common/widgets/touchable_opacity.dart';
import 'package:final_flashcard/core/utils/ui_helpers.dart';
import 'package:final_flashcard/features/learning/presentation/bloc/flashcard_learning_bloc/flashcard_learning_bloc.dart';
import 'package:final_flashcard/features/topic/domain/entities/vocabulary.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FlashcardLearningPage extends StatefulWidget {
  const FlashcardLearningPage({
    super.key,
    required this.termLocale,
    required this.definitionLocale,
  });
  final String termLocale;
  final String definitionLocale;
  @override
  State<FlashcardLearningPage> createState() => _FlashcardLearningPageState();
}

class _FlashcardLearningPageState extends State<FlashcardLearningPage> {
  final FlutterTts _tts = FlutterTts();
  final CardSwiperController _swiperController = CardSwiperController();
  bool _isTermSide = true;
  int seconds = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    initTimer();
  }

  void initTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        seconds++;
      },
    );
  }

  Future<void> speakTerm(String term, int index) async {
    context.read<FlashcardLearningBloc>().add(FlashcardSpeakTerm(index, true));
    _tts.setLanguage(widget.termLocale);
    await _tts.awaitSpeakCompletion(true);
    await _tts.speak(term);
    if (context.mounted) {
      context.read<FlashcardLearningBloc>().add(
            const FlashcardSpeakTerm(-1, false),
          );
    }
  }

  Future<void> speakDefinition(String definition, int index) async {
    context
        .read<FlashcardLearningBloc>()
        .add(FlashcardSpeakDefinition(index, true));
    _tts.setLanguage(widget.definitionLocale);
    await _tts.awaitSpeakCompletion(true);
    await _tts.speak(definition);
    if (context.mounted) {
      context.read<FlashcardLearningBloc>().add(
            const FlashcardSpeakDefinition(-1, false),
          );
    }
  }

  void showFlashcardLearningOptions(BuildContext cntext) async {
    await showModalBottomSheet(
      context: cntext,
      backgroundColor: ColorUtils.getSecondaryBackgroundColor(cntext),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      useSafeArea: true,
      isScrollControlled: true,
      builder: (_) {
        final size = MediaQuery.of(cntext).size;
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: BlocBuilder<FlashcardLearningBloc, FlashcardLearningState>(
            bloc: cntext.read<FlashcardLearningBloc>(),
            builder: (_, state) {
              final shuffled = state.data.shuffleFlashcards;
              final autoRead = state.data.autoSpeak;
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 5,
                    width: size.width * 0.2,
                    decoration: BoxDecoration(
                      color: GlobalColors.primaryColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const Gap(16),
                  Text(
                    "options".tr,
                    style: GoogleFonts.outfit(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      color: ColorUtils.getPrimaryTextColor(cntext),
                    ),
                  ),
                  const Gap(16),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCircularButton(
                        icon: Icon(
                          Icons.shuffle,
                          color: shuffled
                              ? GlobalColors.primaryColor
                              : Colors.white,
                        ),
                        color: GlobalColors.primaryColor,
                        size: 40,
                        title: "shuffle".tr,
                        onPressed: () => cntext
                            .read<FlashcardLearningBloc>()
                            .add(const ShuffleFlashcardsToggle()),
                      ),
                      const Gap(40),
                      _buildCircularButton(
                        icon: Icon(
                          Icons.volume_up,
                          color: autoRead
                              ? GlobalColors.primaryColor
                              : Colors.white,
                        ),
                        color: GlobalColors.primaryColor,
                        size: 40,
                        title: "read_audio".tr,
                        onPressed: () => cntext
                            .read<FlashcardLearningBloc>()
                            .add(const AutoSpeakToggle()),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      },
    );
    if (cntext.mounted) {
      final autoSpeak =
          cntext.read<FlashcardLearningBloc>().state.data.autoSpeak;
      if (autoSpeak) {
        final flashcardLearningBloc = cntext.read<FlashcardLearningBloc>();
        final currentFlashcardIndex =
            flashcardLearningBloc.state.data.currentFlashcardIndex;
        final flashcard =
            flashcardLearningBloc.state.data.topicVocabulariesShuffled;
        if (_isTermSide) {
          speakTerm(flashcard[currentFlashcardIndex].term ?? '',
              currentFlashcardIndex);
        } else {
          speakDefinition(flashcard[currentFlashcardIndex].definition ?? '',
              currentFlashcardIndex);
        }
      }
    }
  }

  Widget _buildCircularButton({
    required VoidCallback onPressed,
    required Icon icon,
    required Color color,
    required double size,
    required String title,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              border: Border.all(
                color: GlobalColors.primaryColor,
                width: 1,
              ),
            ),
            width: size,
            height: size,
            child: Center(child: icon),
          ),
        ),
        const Gap(8),
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 16,
            color: ColorUtils.getPrimaryTextColor(context),
          ),
        ),
      ],
    );
  }

  void autoPlayCard(Vocabulary vocabulary, int currentIndex,
      FlipCardController cardController) async {
    if (_isTermSide) {
      await speakTerm(vocabulary.term ?? '', currentIndex);
    } else {
      await speakDefinition(vocabulary.definition ?? '', currentIndex);
    }
    await cardController.toggleCard();
    setState(() {
      _isTermSide = !_isTermSide;
    });
    if (_isTermSide) {
      await speakTerm(vocabulary.term ?? '', currentIndex);
    } else {
      await speakDefinition(vocabulary.definition ?? '', currentIndex);
    }
    _swiperController.swipe(CardSwiperDirection.right);
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _tts.stop();
    _swiperController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: GlobalColors.primaryColor,
          ),
          onPressed: () {
            _timer?.cancel();
            navigator?.pop();
          },
        ),
        title: BlocConsumer<FlashcardLearningBloc, FlashcardLearningState>(
          listenWhen: ((previous, current) {
            return previous.data.isAutoPlay != current.data.isAutoPlay ||
                current.data.currentFlashcardIndex !=
                    previous.data.currentFlashcardIndex;
          }),
          listener: (_, state) {
            if (state.data.isAutoPlay) {
              final currentIndex = state.data.currentFlashcardIndex;
              final flashcard = state.data.topicVocabulariesShuffled;
              final vocabulary = flashcard[currentIndex];
              final flipCardController =
                  state.data.flipCardControllers[currentIndex];
              autoPlayCard(vocabulary, currentIndex, flipCardController);
            } else {}
          },
          builder: (_, state) {
            final currentFlashcardIndex = state.data.currentFlashcardIndex;
            final totalFlashcard = state.data.totalFlashcard;
            return Text(
              '${currentFlashcardIndex + 1}/$totalFlashcard',
              style: GoogleFonts.outfit(
                fontSize: 22,
                color: GlobalColors.primaryColor,
                fontWeight: FontWeight.w700,
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings_outlined,
              color: GlobalColors.primaryColor,
            ),
            onPressed: () => showFlashcardLearningOptions(context),
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext cntext) {
    return SafeArea(
      child: BlocConsumer<FlashcardLearningBloc, FlashcardLearningState>(
        listener: (_, state) {
          if (state is FlashcardLearningCompleted) {
            _timer?.cancel();
            cntext.read<FlashcardLearningBloc>().add(
                  UpdateLearningStatistics(
                    timeSpent: seconds,
                  ),
                );
          } else if (state is FlashcardLearningError) {
            UIHelpers.showAwesomeDialog(
              context: cntext,
              title: 'error'.tr,
              message: state.data.error,
              type: DialogType.error,
            );
          }
        },
        builder: (_, state) {
          if (state is FlashcardLearningLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is FlashcardLearningUpdateCompleted) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                _buildProgressDivider(cntext),
                const Gap(20),
                _congratulationSection(cntext),
              ],
            );
          }
          return Column(
            children: [
              _buildProgressDivider(cntext),
              const Gap(20),
              _buildFlashcardSection(cntext),
              const Gap(20),
              _buildControlSection(cntext),
              const Gap(20),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFlashcardSection(BuildContext cntext) {
    return BlocBuilder<FlashcardLearningBloc, FlashcardLearningState>(
      builder: (_, state) {
        final flashcard = state.data.topicVocabulariesShuffled;
        final isAutoSpeak = state.data.autoSpeak;
        return flashcard.isNotEmpty
            ? Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CardSwiper(
                    onSwipe: (_, nextIndex, swipeDirection) async {
                      if (nextIndex == null) {
                        if (swipeDirection == CardSwiperDirection.left) {
                          context.read<FlashcardLearningBloc>().add(
                                const NextFlashcard(isLearned: false),
                              );
                        } else if (swipeDirection ==
                            CardSwiperDirection.right) {
                          context.read<FlashcardLearningBloc>().add(
                                const NextFlashcard(isLearned: true),
                              );
                        }
                        return true;
                      }
                      final newIndex = nextIndex;
                      final nextVocabulary = flashcard[newIndex];
                      if (swipeDirection == CardSwiperDirection.left) {
                        context.read<FlashcardLearningBloc>().add(
                              const NextFlashcard(isLearned: false),
                            );
                        if (isAutoSpeak) {
                          await _tts.stop();
                          if (newIndex != -1) {
                            speakTerm(nextVocabulary.term ?? '', newIndex);
                          }
                        }
                        setState(() {
                          _isTermSide = true;
                        });
                        return true;
                      } else if (swipeDirection == CardSwiperDirection.right) {
                        context.read<FlashcardLearningBloc>().add(
                              const NextFlashcard(isLearned: true),
                            );
                        if (isAutoSpeak) {
                          await _tts.stop();
                          if (newIndex != -1 && isAutoSpeak) {
                            speakTerm(nextVocabulary.term ?? '', newIndex);
                          }
                        }
                        setState(() {
                          _isTermSide = true;
                        });
                        return true;
                      }
                      return false;
                    },
                    allowedSwipeDirection:
                        const AllowedSwipeDirection.symmetric(
                      horizontal: true,
                      vertical: false,
                    ),
                    maxAngle: 0,
                    controller: _swiperController,
                    isLoop: false,
                    cardsCount: flashcard.length,
                    numberOfCardsDisplayed: 2,
                    cardBuilder:
                        (_, index, percentThresholdX, percentThresholdY) {
                      final vocabulary = flashcard[index];
                      final speakingIndex = state.data.speakingFlashcardIndex;
                      final isSpeaking = speakingIndex == index;
                      final isTermSpeaking = state.data.isTermSpeaking;
                      final isDefinitionSpeaking =
                          state.data.isDefinitionSpeaking;
                      return FlipCard(
                        controller: state.data.flipCardControllers[index],
                        key: ValueKey(index),
                        direction: FlipDirection.HORIZONTAL,
                        side: CardSide.FRONT,
                        fill: Fill.fillBack,
                        onFlipDone: (isRevert) {
                          setState(() {
                            _isTermSide = !isRevert;
                          });
                          if (isAutoSpeak) {
                            if (isRevert && !isSpeaking) {
                              speakDefinition(
                                  vocabulary.definition ?? '', index);
                            } else if (!isRevert && !isSpeaking) {
                              speakTerm(vocabulary.term ?? '', index);
                            }
                          }
                        },
                        front: _buildFrontSide(
                          vocabulary,
                          isTermSpeaking,
                          isSpeaking,
                          index,
                          percentThresholdX,
                        ),
                        back: _buildBackSide(
                          vocabulary,
                          isDefinitionSpeaking,
                          isSpeaking,
                          index,
                          percentThresholdX,
                        ),
                      );
                    },
                  ),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  Widget _buildFrontSide(
    Vocabulary vocabulary,
    bool isTermSpeaking,
    bool isSpeaking,
    int index,
    int percentThresholdX,
  ) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: GlobalColors.secondaryColor),
              color: ColorUtils.getPrimaryBackgroundColor(context),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            alignment: Alignment.center,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    vocabulary.term ?? '',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      color: isTermSpeaking && isSpeaking
                          ? GlobalColors.primaryColor
                          : ColorUtils.getPrimaryTextColor(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 20,
          bottom: 20,
          child: GestureDetector(
            onTap: () {
              if (!isSpeaking) {
                speakTerm(vocabulary.term ?? '', index);
              }
            },
            child: const Icon(
              Icons.volume_up,
              size: 30,
              color: GlobalColors.primaryColor,
            ),
          ),
        ),
        if (percentThresholdX != 0)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (percentThresholdX > 0)
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: GlobalColors.secondaryColor,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.check,
                            color: GlobalColors.primaryColor,
                            size: 30,
                          ),
                        ),
                      ),
                    )
                  else if (percentThresholdX < 0)
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.redAccent.withOpacity(0.2),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.close,
                            color: Colors.red,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBackSide(
    Vocabulary vocabulary,
    bool isDefinitionSpeaking,
    bool isSpeaking,
    int index,
    int percentThresholdX,
  ) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: GlobalColors.secondaryColor,
              ),
              color: ColorUtils.getPrimaryBackgroundColor(context),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            alignment: Alignment.center,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    vocabulary.definition ?? '',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      color: isDefinitionSpeaking && isSpeaking
                          ? GlobalColors.primaryColor
                          : ColorUtils.getPrimaryTextColor(context),
                    ),
                  ),
                ),
                if (vocabulary.image != null)
                  Expanded(
                    child: CachedNetworkImage(
                      imageUrl: vocabulary.image ?? '',
                      height: 100,
                    ),
                  ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 20,
          bottom: 20,
          child: GestureDetector(
            onTap: () {
              if (!isSpeaking) {
                speakDefinition(
                  vocabulary.definition ?? '',
                  index,
                );
              }
            },
            child: const Icon(
              Icons.volume_up,
              size: 30,
              color: GlobalColors.primaryColor,
            ),
          ),
        ),
        if (percentThresholdX != 0)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (percentThresholdX > 0)
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: GlobalColors.secondaryColor,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.check,
                            color: GlobalColors.primaryColor,
                            size: 30,
                          ),
                        ),
                      ),
                    )
                  else if (percentThresholdX < 0)
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.redAccent.withOpacity(0.2),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.close,
                            color: Colors.red,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildControlSection(BuildContext cntext) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<FlashcardLearningBloc, FlashcardLearningState>(
        builder: (_, state) {
          final currentFlashcardIndex = state.data.currentFlashcardIndex;
          final autoPlay = state.data.isAutoPlay;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  if (currentFlashcardIndex != 0 && !autoPlay) {
                    cntext
                        .read<FlashcardLearningBloc>()
                        .add(const PreviousFlashcard());
                    _swiperController.undo();
                  }
                },
                icon: Icon(
                  Icons.restore,
                  color: currentFlashcardIndex != 0 && !autoPlay
                      ? GlobalColors.primaryColor
                      : GlobalColors.primaryColor.withOpacity(0.2),
                ),
              ),
              IconButton(
                onPressed: () {
                  cntext.read<FlashcardLearningBloc>().add(
                        const AutoPlayToggle(),
                      );
                },
                icon: Icon(
                  autoPlay
                      ? Icons.stop_circle_outlined
                      : Icons.play_arrow_rounded,
                  color: GlobalColors.primaryColor,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProgressDivider(BuildContext cntext) {
    return BlocBuilder<FlashcardLearningBloc, FlashcardLearningState>(
      builder: (_, state) {
        final currentFlashcardIndex = state.data.currentFlashcardIndex;
        final totalFlashcard = state.data.totalFlashcard;
        return totalFlashcard != 0
            ? LinearProgressIndicator(
                value: (currentFlashcardIndex + 1) / totalFlashcard,
                backgroundColor: GlobalColors.secondaryColor,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  GlobalColors.primaryColor,
                ),
              )
            : const SizedBox.shrink();
      },
    );
  }

  Widget _congratulationSection(BuildContext cntext) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: BlocBuilder<FlashcardLearningBloc, FlashcardLearningState>(
          builder: (_, state) {
            final learnedFlashcards = state.data.learnedVocabularies;
            final notLearnedFlashcards = state.data.notLearnedVocabularies;
            final totalFlashcard = state.data.totalFlashcard;
            final percentage =
                (learnedFlashcards.length / totalFlashcard) * 100;
            return Column(
              children: [
                const Icon(
                  Icons.check_circle_outline_rounded,
                  color: GlobalColors.primaryColor,
                  size: 100,
                ),
                const Gap(16),
                Text(
                  "congratulations".tr,
                  style: GoogleFonts.outfit(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: ColorUtils.getPrimaryTextColor(cntext),
                  ),
                ),
                const Gap(16),
                Text(
                  "congratulations_desc".tr,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    color: ColorUtils.getPrimaryTextColor(cntext),
                  ),
                ),
                const Gap(60),
                Expanded(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned.fill(
                              child: CircularProgressIndicator(
                                value: percentage / 100,
                                strokeWidth: 10,
                                backgroundColor: GlobalColors.orangeColor,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  GlobalColors.primaryColor,
                                ),
                              ),
                            ),
                            Text(
                              '${percentage.toStringAsFixed(0)}%',
                              style: GoogleFonts.outfit(
                                fontSize: 20,
                                color: ColorUtils.getPrimaryTextColor(cntext),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(30),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'learned'.tr,
                                  style: GoogleFonts.outfit(
                                    fontSize: 20,
                                    color: GlobalColors.primaryColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: GlobalColors.primaryColor,
                                    ),
                                  ),
                                  width: 40,
                                  height: 40,
                                  child: Center(
                                    child: Text(
                                      '${learnedFlashcards.length}',
                                      style: GoogleFonts.outfit(
                                        fontSize: 20,
                                        color: GlobalColors.primaryColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Gap(16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'not_learned'.tr,
                                  style: GoogleFonts.outfit(
                                    fontSize: 20,
                                    color: GlobalColors.orangeColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: GlobalColors.orangeColor,
                                    ),
                                  ),
                                  width: 40,
                                  height: 40,
                                  child: Center(
                                    child: Text(
                                      '${notLearnedFlashcards.length}',
                                      style: GoogleFonts.outfit(
                                        fontSize: 20,
                                        color: GlobalColors.orangeColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(20),
                TouchableOpacity(
                  color: GlobalColors.primaryColor,
                  onPressed: () {
                    navigator?.pop();
                  },
                  child: Text(
                    'back'.tr,
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Gap(10),
                TouchableOpacity(
                  color: GlobalColors.primaryColor,
                  onPressed: () {
                    cntext.read<FlashcardLearningBloc>().add(
                          InitFlashcardLearning(
                            topic: state.data.topic!,
                            selectedVocabularies: state.data.topicVocabularies,
                          ),
                        );
                  },
                  child: Text(
                    'restart'.tr,
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Gap(20),
              ],
            );
          },
        ),
      ),
    );
  }
}
