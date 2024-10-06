import 'dart:async';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:final_flashcard/configs/common/widgets/custom_main_switch.dart';
import 'package:final_flashcard/configs/common/widgets/custom_text_form_field.dart';
import 'package:final_flashcard/configs/common/widgets/three_dimensional_button.dart';
import 'package:final_flashcard/configs/common/widgets/touchable_opacity.dart';
import 'package:final_flashcard/configs/routes/route_generator.dart';
import 'package:final_flashcard/core/utils/ui_helpers.dart';
import 'package:final_flashcard/features/learning/domain/entities/quiz.dart';
import 'package:final_flashcard/features/learning/presentation/bloc/typing_learning_bloc/typing_learning_bloc.dart';
import 'package:final_flashcard/features/learning/presentation/widgets/typing_text_form_field.dart';
import 'package:final_flashcard/features/learning/presentation/widgets/your_answer_card.dart';
import 'package:final_flashcard/features/topic/domain/entities/topic.dart';
import 'package:final_flashcard/features/topic/domain/entities/vocabulary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class TypingLearningPage extends StatefulWidget {
  const TypingLearningPage({
    super.key,
    required this.termLocale,
    required this.definitionLocale,
    required this.questionCount,
  });
  final String termLocale;
  final String definitionLocale;
  final int questionCount;

  @override
  State<TypingLearningPage> createState() => _TypingLearningPageState();
}

class _TypingLearningPageState extends State<TypingLearningPage> {
  final FlutterTts _tts = FlutterTts();
  final TextEditingController _questionCountController =
      TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  Timer? _timer;
  int _seconds = 0;
  @override
  void initState() {
    super.initState();
    _questionCountController.text = widget.questionCount.toString();
  }

  void initTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds++;
    });
  }

  void _speak(
    Quiz currentQuiz,
    bool isPromptTerm,
    bool isPromptDefinition,
  ) async {
    if (isPromptTerm) {
      await _tts.setLanguage(widget.termLocale);
      await _tts.speak(currentQuiz.vocabulary?.term ?? '');
    } else if (isPromptDefinition) {
      await _tts.setLanguage(widget.definitionLocale);
      await _tts.speak(currentQuiz.vocabulary?.definition ?? '');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _tts.stop();
    _questionCountController.dispose();
  }

  void _showChangeAnswerWithBottomSheet(BuildContext cntext) async {
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
          child: BlocBuilder<TypingLearningBloc, TypingLearningState>(
            bloc: cntext.read<TypingLearningBloc>(),
            builder: (_, state) {
              final answerTerm = state.data.answerTerm;
              final answerDefinition = state.data.answerDefinition;
              final promptTerm = state.data.promptTerm;
              final promptDefinition = state.data.promptDefinition;
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 5,
                      width: size.width * 0.2,
                      decoration: BoxDecoration(
                        color: GlobalColors.primaryColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const Gap(16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "answer_options".tr,
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: ColorUtils.getPrimaryTextColor(cntext),
                      ),
                    ),
                  ),
                  const Gap(16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'answer_with'.tr,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: ColorUtils.getPrimaryTextColor(cntext),
                      ),
                    ),
                  ),
                  const Gap(10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'term'.tr,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: ColorUtils.getPrimaryTextColor(cntext),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: CustomMainSwitch(
                              onChanged: (val) {
                                cntext.read<TypingLearningBloc>().add(
                                      ChangeTypingAnswerWith(
                                        answerTerm: val,
                                        answerDefinition: answerDefinition,
                                      ),
                                    );
                              },
                              value: answerTerm,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'definition'.tr,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: ColorUtils.getPrimaryTextColor(cntext),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: CustomMainSwitch(
                              onChanged: (val) {
                                cntext.read<TypingLearningBloc>().add(
                                      ChangeTypingAnswerWith(
                                        answerTerm: answerTerm,
                                        answerDefinition: val,
                                      ),
                                    );
                              },
                              value: answerDefinition,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'prompt_with'.tr,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: ColorUtils.getPrimaryTextColor(cntext),
                      ),
                    ),
                  ),
                  const Gap(10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'term'.tr,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: ColorUtils.getPrimaryTextColor(cntext),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: CustomMainSwitch(
                              onChanged: (val) {
                                cntext.read<TypingLearningBloc>().add(
                                      ChangeTypingPromptWith(
                                        promptTerm: val,
                                        promptDefinition: promptDefinition,
                                      ),
                                    );
                              },
                              value: promptTerm,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'definition'.tr,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: ColorUtils.getPrimaryTextColor(cntext),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: CustomMainSwitch(
                              onChanged: (val) {
                                cntext.read<TypingLearningBloc>().add(
                                      ChangeTypingPromptWith(
                                        promptTerm: promptTerm,
                                        promptDefinition: val,
                                      ),
                                    );
                              },
                              value: promptDefinition,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TypingLearningBloc, TypingLearningState>(
        builder: (_, state) {
      return Scaffold(
        resizeToAvoidBottomInset: state is TypingLearningLoaded,
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
          title: BlocBuilder<TypingLearningBloc, TypingLearningState>(
            builder: (_, state) {
              final currentFlashcardIndex = state.data.currentQuizIndex;
              final totalQuizzes = state.data.quizzes.length;
              if (state is TypingLearningLoaded ||
                  state is TypingLearningCorrectAnswer ||
                  state is TypingLearningWrongAnswer ||
                  state is TypingLearningFinished) {
                return Text(
                  '${currentFlashcardIndex + 1}/$totalQuizzes',
                  style: GoogleFonts.outfit(
                    fontSize: 22,
                    color: GlobalColors.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                );
              }
              return Text(
                'typing_settings'.tr,
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  color: GlobalColors.primaryColor,
                  fontWeight: FontWeight.w700,
                ),
              );
            },
          ),
        ),
        body: _buildBody(context),
      );
    });
  }

  Widget _buildBody(BuildContext cntext) {
    return SafeArea(
      child: BlocConsumer<TypingLearningBloc, TypingLearningState>(
        listener: (_, state) {
          if (state is TypingLearningFinished) {
            _timer?.cancel();
            cntext.read<TypingLearningBloc>().add(
                  UpdateTypingLearningStatistics(
                    seconds: _seconds,
                  ),
                );
          } else if (state is TypingLearningError) {
            final errorMsg = state.data.error;
            UIHelpers.showAwesomeDialog(
              context: cntext,
              title: 'error'.tr,
              message: errorMsg.tr,
              type: DialogType.error,
              onOkPressed: () {
                cntext.read<TypingLearningBloc>().add(const TypingClearError());
              },
            );
          } else if (state is TypingLearningWrongAnswer) {
            final currentQuiz = state.data.quizzes[state.data.currentQuizIndex];
            final findDefinition = currentQuiz.findDefinition;
            final vocabulary = currentQuiz.vocabulary;
            final correctAnswer = findDefinition ?? false
                ? vocabulary?.definition ?? ''
                : vocabulary?.term ?? '';
            UIHelpers.showAwesomeDialog(
              context: cntext,
              title: 'wrong_answer'.tr,
              message: '${'correct_answer_is'.tr} $correctAnswer'.tr,
              type: DialogType.error,
              onOkPressed: () {
                cntext.read<TypingLearningBloc>().add(const TypingNextQuiz());
              },
            );
          } else if (state is TypingLearningCorrectAnswer) {
            UIHelpers.showAwesomeDialog(
              context: cntext,
              title: 'correct_answer'.tr,
              message: 'chosen_correct_answer'.tr,
              type: DialogType.success,
              onOkPressed: () {
                cntext.read<TypingLearningBloc>().add(const TypingNextQuiz());
              },
            );
          }
        },
        builder: (_, state) {
          if (state is TypingLearningInitial ||
              state is TypingLearningFinished) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is TypingLearningLoaded ||
              state is TypingLearningCorrectAnswer ||
              state is TypingLearningWrongAnswer) {
            return _buildQuizBody(cntext);
          }
          if (state is TypingLearningUpdatedLearningStatistics) {
            return _buildQuizFinishedBody(cntext);
          }
          final answerTerm = state.data.answerTerm;
          final answerDefinition = state.data.answerDefinition;
          final promptTerm = state.data.promptTerm;
          final promptDefinition = state.data.promptDefinition;
          final cantContinue = (!answerTerm && !answerDefinition) ||
              (!promptTerm && !promptDefinition);
          return Column(
            children: [
              _buildSettingsHeader(cntext),
              const Gap(20),
              _buildSettingsBody(cntext),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ThreeDimensionalButton(
                  onPressed: () {
                    if (cantContinue) return;
                    final questionCount = int.tryParse(
                      _questionCountController.text,
                    );
                    initTimer();
                    cntext.read<TypingLearningBloc>().add(
                          TypingStartQuiz(
                            questionCount: questionCount ?? 0,
                          ),
                        );
                  },
                  buttonText: 'start_quiz'.tr,
                  color: GlobalColors.primaryColor.withOpacity(
                    cantContinue ? 0.2 : 1,
                  ),
                ),
              ),
              const Gap(16)
            ],
          );
        },
      ),
    );
  }

  Widget _buildSettingsHeader(BuildContext cntext) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<TypingLearningBloc, TypingLearningState>(
        builder: (_, state) {
          final topic = state.data.topic;
          return Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic?.title ?? '',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: ColorUtils.getPrimaryTextColor(
                          cntext,
                        ),
                      ),
                    ),
                    const Gap(4),
                    Text(
                      'set_up_your_typing'.tr,
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: ColorUtils.getPrimaryTextColor(
                          cntext,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SvgPicture.asset(
                'assets/images/flashcard_icon.svg',
                width: 40,
                height: 40,
                colorFilter: const ColorFilter.mode(
                  GlobalColors.primaryColor,
                  BlendMode.srcIn,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSettingsBody(BuildContext cntext) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<TypingLearningBloc, TypingLearningState>(
        builder: (_, state) {
          final quizNumber = state.data.quizzes.length;
          final instantFeedback = state.data.instantFeedback;
          final shuffle = state.data.shuffle;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        text: "${'quiz_count'.tr} ",
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: ColorUtils.getPrimaryTextColor(
                            cntext,
                          ),
                        ),
                        children: [
                          TextSpan(
                            text: '(${'max'.tr} $quizNumber)',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: ColorUtils.getSecondaryTextColor(
                                cntext,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: CustomTextFormField(
                      textEditingController: _questionCountController,
                      labelText: 'quiz_count'.tr,
                      isDigitsOnly: true,
                    ),
                  ),
                ],
              ),
              const Gap(10),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'instant_feedback'.tr,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: ColorUtils.getPrimaryTextColor(
                          cntext,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: CustomMainSwitch(
                        onChanged: (val) {
                          cntext.read<TypingLearningBloc>().add(
                                ChangeTypingInstantFeedback(
                                  instantFeedback: val,
                                ),
                              );
                        },
                        value: instantFeedback,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(10),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'shuffle'.tr,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: ColorUtils.getPrimaryTextColor(
                          cntext,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: CustomMainSwitch(
                        onChanged: (val) {
                          cntext.read<TypingLearningBloc>().add(
                                ChangeTypingShuffle(
                                  shuffle: val,
                                ),
                              );
                        },
                        value: shuffle,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(10),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'answer_with'.tr,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: ColorUtils.getPrimaryTextColor(
                          cntext,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () =>
                            _showChangeAnswerWithBottomSheet(cntext),
                        icon: const Icon(
                          CupertinoIcons.chevron_right,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildQuizBody(BuildContext cntext) {
    return BlocBuilder<TypingLearningBloc, TypingLearningState>(
      builder: (_, state) {
        final currentQuiz = state.data.quizzes[state.data.currentQuizIndex];
        bool isPromptTerm = state.data.promptTerm;
        bool isPromptDefinition = state.data.promptDefinition;
        bool isPromptBoth = isPromptTerm && isPromptDefinition;
        if (isPromptBoth) {
          isPromptTerm = Random().nextBool();
          isPromptDefinition = !isPromptTerm;
        }
        bool isAnswerTerm = state.data.answerTerm;
        bool isAnswerDefinition = state.data.answerDefinition;
        bool isAnswerBoth = isAnswerTerm && isAnswerDefinition;
        if (isAnswerBoth) {
          if (isPromptDefinition) {
            isAnswerTerm = true;
            isAnswerDefinition = !isAnswerTerm;
          } else {
            isAnswerDefinition = true;
            isAnswerTerm = !isAnswerDefinition;
          }
        }
        if (state is! TypingLearningLoaded) {
          return const SizedBox.shrink();
        }
        final currentQuizIndex = state.data.currentQuizIndex;
        final totalQuiz = state.data.quizzes.length;
        return Column(
          children: [
            totalQuiz != 0
                ? LinearProgressIndicator(
                    value: (currentQuizIndex + 1) / totalQuiz,
                    backgroundColor: GlobalColors.secondaryColor,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      GlobalColors.primaryColor,
                    ),
                  )
                : const SizedBox.shrink(),
            const Gap(20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: GestureDetector(
                    onTap: () => _speak(
                      currentQuiz,
                      isPromptTerm,
                      isPromptDefinition,
                    ),
                    child: Text(
                      isPromptTerm
                          ? currentQuiz.vocabulary?.term ?? ''
                          : isPromptDefinition
                              ? currentQuiz.vocabulary?.definition ?? ''
                              : '',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: ColorUtils.getPrimaryTextColor(cntext),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16)
                  .copyWith(bottom: 16),
              child: TypingTextFormField(
                controller: _answerController,
                onFieldSubmitted: (val) {
                  cntext.read<TypingLearningBloc>().add(
                        AnswerTypingQuiz(
                          answer: _answerController.text,
                          findDefinition: isAnswerDefinition,
                          isPromptTerm: isPromptTerm,
                        ),
                      );
                  _answerController.clear();
                },
                labelText: isAnswerTerm
                    ? 'term'.tr
                    : isAnswerDefinition
                        ? 'definition'.tr
                        : '',
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        cntext.read<TypingLearningBloc>().add(
                              AnswerTypingQuiz(
                                answer: '',
                                findDefinition: isAnswerDefinition,
                                isPromptTerm: isPromptTerm,
                              ),
                            );
                        _answerController.clear();
                      },
                      child: Text(
                        'dont_know'.tr,
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: GlobalColors.primaryColor,
                        ),
                      ),
                    ),
                    const Gap(10),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildQuizFinishedBody(BuildContext cntext) {
    return BlocBuilder<TypingLearningBloc, TypingLearningState>(
      builder: (_, state) {
        final correctQuizzes = state.data.quizzes.where((quiz) {
          return quiz.isCorrect ?? false;
        }).toList();
        final currentQuizIndex = state.data.currentQuizIndex;
        final totalQuizzes = state.data.quizzes.length;
        final percentage = (correctQuizzes.length / totalQuizzes) * 100;
        final topic = state.data.topic;
        final quizzes = state.data.quizzes;
        return SingleChildScrollView(
          child: Column(
            children: [
              totalQuizzes != 0
                  ? LinearProgressIndicator(
                      value: (currentQuizIndex + 1) / totalQuizzes,
                      backgroundColor: GlobalColors.secondaryColor,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        GlobalColors.primaryColor,
                      ),
                    )
                  : const SizedBox.shrink(),
              const Gap(30),
              _buildResultHeader(percentage, cntext),
              const Gap(60),
              _buildYourResult(
                cntext,
                percentage,
                correctQuizzes,
                totalQuizzes,
              ),
              const Gap(30),
              _buildNextStep(cntext, topic!, state.data.vocabularies),
              const Gap(60),
              _buildYourAnswers(cntext, quizzes),
            ],
          ),
        );
      },
    );
  }

  Widget _buildResultHeader(double percentage, BuildContext cntext) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  percentage <= 50
                      ? 'you_can_do_better'.tr
                      : percentage <= 80
                          ? 'good_job'.tr
                          : 'excellent'.tr,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: ColorUtils.getPrimaryTextColor(cntext),
                  ),
                ),
                const Gap(4),
                Text(
                  percentage <= 50
                      ? 'you_can_do_better_desc'.tr
                      : percentage <= 80
                          ? 'good_job_desc'.tr
                          : 'excellent_desc'.tr,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: ColorUtils.getPrimaryTextColor(cntext),
                  ),
                ),
              ],
            ),
          ),
          SvgPicture.asset(
            'assets/images/idea_icon.svg',
            width: 100,
            height: 100,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  Widget _buildYourResult(BuildContext cntext, double percentage,
      List<Quiz> correctQuizzes, int totalQuizzes) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'your_result'.tr,
            style: GoogleFonts.outfit(
              fontSize: 20,
              color: ColorUtils.getPrimaryTextColor(
                cntext,
              ),
            ),
          ),
          const Gap(16),
          Row(
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
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'correct_answer'.tr,
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
                              '${correctQuizzes.length}',
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
                          'wrong_answer'.tr,
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
                              '${totalQuizzes - correctQuizzes.length}',
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
        ],
      ),
    );
  }

  Widget _buildNextStep(
      BuildContext cntext, Topic topic, List<Vocabulary> selectedVocabularies) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'next_step'.tr,
            style: GoogleFonts.outfit(
              fontSize: 20,
              color: ColorUtils.getPrimaryTextColor(
                cntext,
              ),
            ),
          ),
          const Gap(16),
          TouchableOpacity(
            color: GlobalColors.primaryColor,
            onPressed: () {
              final typingLearningBloc = cntext.read<TypingLearningBloc>();
              navigator?.popAndPushNamed(
                RouteGenerator.learningFlashcard,
                arguments: {
                  'TOPIC': topic,
                  'VOCABULARIES': typingLearningBloc.state.data.vocabularies,
                },
              );
            },
            child: Text(
              'review_flashcard'.tr,
              style: GoogleFonts.outfit(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
          const Gap(10),
          TouchableOpacity(
            color: GlobalColors.primaryColor,
            onPressed: () {
              cntext.read<TypingLearningBloc>().add(
                    InitTypingLearning(
                        topic: topic,
                        selectedVocabularies: selectedVocabularies),
                  );
            },
            child: Text(
              'restart'.tr,
              style: GoogleFonts.outfit(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYourAnswers(BuildContext cntext, List<Quiz> quizzes) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'your_answer'.tr,
            style: GoogleFonts.outfit(
              fontSize: 20,
              color: ColorUtils.getPrimaryTextColor(
                cntext,
              ),
            ),
          ),
          const Gap(16),
          ListView.separated(
            separatorBuilder: (_, __) => const Gap(16),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: quizzes.length,
            itemBuilder: (_, index) {
              final quiz = quizzes[index];
              return YourAnswerCard(
                isCorrect: quiz.isCorrect!,
                isFindDefinition: quiz.findDefinition!,
                isPromptTerm: quiz.isPromptTerm!,
                question: quiz.vocabulary!,
                answerText: quiz.answerText,
              );
            },
          ),
          const Gap(16),
        ],
      ),
    );
  }
}
