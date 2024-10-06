import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:final_flashcard/configs/common/widgets/touchable_opacity.dart';
import 'package:final_flashcard/configs/routes/route_generator.dart';
import 'package:final_flashcard/core/utils/ui_helpers.dart';
import 'package:final_flashcard/di/di_config.dart';
import 'package:final_flashcard/features/topic/domain/entities/topic.dart';
import 'package:final_flashcard/features/topic/domain/entities/vocabulary.dart';
import 'package:final_flashcard/features/topic/presentation/bloc/add_topic_bloc/add_topic_bloc.dart'
    as addTopicBloc;
import 'package:final_flashcard/features/topic/presentation/bloc/topic_details/topic_details_bloc.dart';
import 'package:final_flashcard/features/topic/presentation/widgets/card_item.dart';
import 'package:final_flashcard/features/topic/presentation/widgets/circular_avatar.dart';
import 'package:final_flashcard/features/topic/presentation/widgets/vocabulary_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TopicDetailsPage extends StatefulWidget {
  const TopicDetailsPage({
    super.key,
    required this.termLanguage,
    required this.definitionLanguage,
  });
  final String termLanguage;
  final String definitionLanguage;

  @override
  State<TopicDetailsPage> createState() => _TopicDetailsPageState();
}

class _TopicDetailsPageState extends State<TopicDetailsPage> {
  final PageController _flashcardsPageController = PageController(
    viewportFraction: 1,
  );
  final ScrollController _screenScrollController = ScrollController();

  final FlutterTts _tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    setUpScrollListener();
  }

  void favoriteVocabulary(int vocabularyId) {
    context
        .read<TopicDetailsBloc>()
        .add(FavoriteVocabulary(vocabId: vocabularyId));
  }

  void setUpScrollListener() {
    _screenScrollController.addListener(
      () {
        if (_screenScrollController.offset >= Get.height * 0.3) {
          context.read<TopicDetailsBloc>().add(
                const TopicDetailsEvent.toggleLearnButtonBottom(
                  showLearnButtonBottom: true,
                ),
              );
        } else {
          context.read<TopicDetailsBloc>().add(
                const TopicDetailsEvent.toggleLearnButtonBottom(
                  showLearnButtonBottom: false,
                ),
              );
        }
      },
    );
  }

  void onTtsPressed(Vocabulary vocabulary, int index) async {
    context.read<TopicDetailsBloc>().add(
          TopicDetailsEvent.toggleSpeakingStatus(
            vocabIndex: index,
            isTermSpeaking: true,
            isDefinitionSpeaking: false,
          ),
        );
    await _tts.setLanguage(widget.termLanguage);
    await _tts.awaitSpeakCompletion(true);
    await _tts.speak(vocabulary.term ?? '');
    if (context.mounted) {
      context.read<TopicDetailsBloc>().add(
            TopicDetailsEvent.toggleSpeakingStatus(
              vocabIndex: index,
              isTermSpeaking: false,
              isDefinitionSpeaking: true,
            ),
          );
    }
    await _tts.setLanguage(widget.definitionLanguage);
    await _tts.awaitSpeakCompletion(true);
    await _tts.speak(vocabulary.definition ?? '');
    if (context.mounted) {
      context.read<TopicDetailsBloc>().add(
            const TopicDetailsEvent.toggleSpeakingStatus(
              vocabIndex: -1,
              isTermSpeaking: false,
              isDefinitionSpeaking: false,
            ),
          );
    }
  }

  void onTermPressed(Vocabulary vocabulary, int index) async {
    context.read<TopicDetailsBloc>().add(
          TopicDetailsEvent.toggleSpeakingStatus(
            vocabIndex: index,
            isTermSpeaking: true,
            isDefinitionSpeaking: false,
          ),
        );
    await _tts.setLanguage(widget.termLanguage);
    await _tts.awaitSpeakCompletion(true);
    await _tts.speak(vocabulary.term ?? '');
    if (context.mounted) {
      context.read<TopicDetailsBloc>().add(
            const TopicDetailsEvent.toggleSpeakingStatus(
              vocabIndex: -1,
              isTermSpeaking: false,
              isDefinitionSpeaking: false,
            ),
          );
    }
  }

  void onDefinitionPressed(Vocabulary vocabulary, int index) async {
    context.read<TopicDetailsBloc>().add(
          TopicDetailsEvent.toggleSpeakingStatus(
            vocabIndex: index,
            isTermSpeaking: false,
            isDefinitionSpeaking: true,
          ),
        );
    await _tts.setLanguage(widget.definitionLanguage);
    await _tts.awaitSpeakCompletion(true);
    await _tts.speak(vocabulary.definition ?? '');
    if (context.mounted) {
      context.read<TopicDetailsBloc>().add(
            const TopicDetailsEvent.toggleSpeakingStatus(
              vocabIndex: -1,
              isTermSpeaking: false,
              isDefinitionSpeaking: false,
            ),
          );
    }
  }

  void _showConfirmDeleteTopic(BuildContext cntext) {
    navigator?.pop();
    UIHelpers.showAwesomeDialog(
      context: cntext,
      title: 'confirmation'.tr,
      message: 'delete_topic_confirm_msg'.tr,
      type: DialogType.warning,
      btnCancel: 'cancel'.tr,
      onCancelPressed: () {},
      onOkPressed: () {
        context.read<TopicDetailsBloc>().add(
              const DeleteTopic(),
            );
      },
    );
  }

  void _onEditTopicPressed(Topic topic, BuildContext cntext) async {
    final res = await navigator!.pushNamed<addTopicBloc.AddTopicBloc>(
      RouteGenerator.addTopic,
      arguments: {
        'TOPIC': topic,
        'ADD_TOPIC_BLOC': addTopicBloc.AddTopicBloc(
          getIt.get(),
          getIt.get(),
          getIt.get(),
          getIt.get(),
        ),
      },
    );
    navigator?.pop();
    if (res != null && cntext.mounted) {
      _addPendingBloc(res, cntext);
    }
  }

  void _addPendingBloc(addTopicBloc.AddTopicBloc bloc, BuildContext cntext) {
    cntext.read<TopicDetailsBloc>().add(
          TopicDetailsEvent.addPendingTopicBloc(addTopicBloc: bloc),
        );
  }

  void _showTopicOptions() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: ColorUtils.getSecondaryBackgroundColor(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      useSafeArea: true,
      isScrollControlled: true,
      builder: (_) {
        final size = MediaQuery.of(context).size;
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: BlocBuilder<TopicDetailsBloc, TopicDetailsState>(
              bloc: context.read<TopicDetailsBloc>(),
              builder: (_, state) {
                final userId = state.data.userId;
                final topic = state.data.topic;
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TouchableOpacity(
                        color: Colors.transparent,
                        borderColor: GlobalColors.primaryColor,
                        onPressed: () async {
                          await navigator?.pushNamed(
                            RouteGenerator.learningRankings,
                            arguments: {
                              'TOPIC': topic,
                            },
                          ).whenComplete(() {
                            navigator?.pop();
                            context.read<TopicDetailsBloc>().add(
                                  GetTopicDetails(
                                    topicId: topic!.id!,
                                    userId: userId!,
                                  ),
                                );
                          });
                        },
                        child: Row(
                          children: [
                            const Icon(
                              FontAwesomeIcons.trophy,
                              color: GlobalColors.primaryColor,
                            ),
                            const Gap(16),
                            Text(
                              'rankings'.tr,
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: GlobalColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TouchableOpacity(
                        color: Colors.transparent,
                        borderColor: GlobalColors.primaryColor,
                        onPressed: () {
                          if (topic?.isDownloaded == false ||
                              topic?.isDownloaded == null) {
                            context.read<TopicDetailsBloc>().add(
                                  TopicDetailsEvent.downloadTopicToLocal(
                                    topic: topic!,
                                    userId: state.data.userId!,
                                  ),
                                );
                          }
                        },
                        child: Row(
                          children: [
                            Icon(
                              topic?.isDownloaded == false
                                  ? Icons.download_rounded
                                  : Icons.check_circle_outline,
                              color: GlobalColors.primaryColor,
                            ),
                            const Gap(16),
                            Text(
                              topic?.isDownloaded == false
                                  ? 'download_for_offline_use'.tr
                                  : 'downloaded'.tr,
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: GlobalColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TouchableOpacity(
                        color: Colors.transparent,
                        borderColor: GlobalColors.primaryColor,
                        onPressed: () {
                          navigator?.pushNamed(
                            RouteGenerator.addFolderToTopic,
                            arguments: {
                              'TOPIC': topic,
                            },
                          );
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.folder,
                              color: GlobalColors.primaryColor,
                            ),
                            const Gap(16),
                            Text(
                              'add_topic_to_folder'.tr,
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: GlobalColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (userId == topic?.user?.id) ...[
                      const Gap(10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TouchableOpacity(
                          color: Colors.transparent,
                          borderColor: GlobalColors.primaryColor,
                          onPressed: () => _onEditTopicPressed(topic!, context),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.edit,
                                color: GlobalColors.primaryColor,
                              ),
                              const Gap(16),
                              Text(
                                'edit'.tr,
                                style: GoogleFonts.outfit(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: GlobalColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Gap(10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TouchableOpacity(
                          color: Colors.transparent,
                          borderColor: GlobalColors.primaryColor,
                          onPressed: () => _showConfirmDeleteTopic(context),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.delete,
                                color: GlobalColors.primaryColor,
                              ),
                              const Gap(16),
                              Text(
                                'delete'.tr,
                                style: GoogleFonts.outfit(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: GlobalColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]
                  ],
                );
              }),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _flashcardsPageController.dispose();
    _tts.stop();
    _screenScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: GlobalColors.primaryColor,
          ),
          onPressed: () {
            navigator?.pop();
          },
        ),
        title: BlocBuilder<TopicDetailsBloc, TopicDetailsState>(
          builder: (_, state) {
            final topic = state.data.topic;
            return Text(
              topic?.title ?? '',
              style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: GlobalColors.primaryColor,
              ),
            );
          },
        ),
        actions: [
          BlocBuilder<TopicDetailsBloc, TopicDetailsState>(
            builder: (_, state) {
              return IconButton(
                icon: const Icon(
                  FontAwesomeIcons.ellipsisVertical,
                  color: GlobalColors.primaryColor,
                ),
                onPressed: () {
                  if (state.data.addTopicBloc == null) {
                    _showTopicOptions();
                  }
                },
              );
            },
          )
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext cntext) {
    return SafeArea(
      child: BlocConsumer<TopicDetailsBloc, TopicDetailsState>(
        listener: (_, state) {
          if (state is TopicDetailsDeleteTopicError) {
            UIHelpers.showAwesomeDialog(
              context: context,
              title: 'error'.tr,
              message: state.data.error.tr,
              type: DialogType.error,
              onOkPressed: () {
                navigator?.pop();
              },
            );
          } else if (state is TopicDetailsDeleteTopicSuccess) {
            navigator?.pop();
          } else if (state is TopicDetailsExportToCsvSuccess) {
            UIHelpers.showAwesomeDialog(
              context: context,
              title: 'success'.tr,
              message: 'export_to_csv_success'.tr,
              type: DialogType.success,
              onOkPressed: () {
                cntext.read<TopicDetailsBloc>().add(
                      GetTopicDetails(
                        topicId: state.data.topic!.id!,
                        userId: state.data.userId!,
                      ),
                    );
              },
            );
          } else if (state is TopicDetailsExportToCsvFailed) {
            UIHelpers.showAwesomeDialog(
              context: context,
              title: 'error'.tr,
              message: 'export_to_csv_failed'.tr,
              type: DialogType.success,
              onOkPressed: () {
                cntext.read<TopicDetailsBloc>().add(
                      GetTopicDetails(
                        topicId: state.data.topic!.id!,
                        userId: state.data.userId!,
                      ),
                    );
              },
            );
          }
        },
        builder: (_, state) {
          if (state.data.topic == null && state is TopicDetailsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.data.addTopicBloc != null) {
            final pendingAddTopicBloc = state.data.addTopicBloc;
            return _buildPendingTopicPage(pendingAddTopicBloc, cntext);
          } else if (state.data.topic != null) {
            return Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(
                  child: SingleChildScrollView(
                    controller: _screenScrollController,
                    child: Column(
                      children: [
                        _buildFlashcardsPageView(cntext),
                        const Gap(10),
                        _buildTopicHeader(cntext),
                        const Gap(10),
                        _buildExportToCsvButton(cntext),
                        const Gap(20),
                        _buildLearningMethods(cntext),
                        const Gap(20),
                        _buildVocabulariesList(cntext),
                        const Gap(60),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: BlocBuilder<TopicDetailsBloc, TopicDetailsState>(
                    builder: (_, state) {
                      final topic = state.data.topic;
                      final favoriteVocabularies =
                          state.data.favoriteVocabularies;
                      final isStudyAll = state.data.learnAll;
                      if (state.data.showLearnButtonBottom) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: TouchableOpacity(
                            color: GlobalColors.primaryColor,
                            onPressed: () {
                              navigator?.pushNamed(
                                RouteGenerator.learningFlashcard,
                                arguments: {
                                  'TOPIC': topic,
                                  'VOCABULARIES': favoriteVocabularies.isEmpty
                                      ? state.data.topic?.vocabularies
                                      : isStudyAll
                                          ? state.data.topic?.vocabularies
                                          : favoriteVocabularies
                                },
                              );
                            },
                            child: Text(
                              'learn'.tr,
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildFlashcardsPageView(BuildContext cntext) {
    return BlocBuilder<TopicDetailsBloc, TopicDetailsState>(
        builder: (_, state) {
      final flashcards = state.data.topic?.vocabularies ?? [];
      return Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            height: Get.height * 0.3,
            child: PageView.builder(
              controller: _flashcardsPageController,
              itemBuilder: (_, index) {
                final vocabulary = flashcards[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ).copyWith(top: 8, bottom: 20),
                  child: VocabularyItem(
                    term: vocabulary.term ?? '',
                    definition: vocabulary.definition ?? '',
                    imageUrl: vocabulary.image,
                  ),
                );
              },
              itemCount: flashcards.length,
            ),
          ),
          const Gap(10),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: SmoothPageIndicator(
              controller: _flashcardsPageController,
              count: flashcards.length,
              effect: SlideEffect(
                spacing: 8,
                dotHeight: 10,
                dotWidth: 10,
                radius: 16,
                paintStyle: PaintingStyle.fill,
                activeDotColor: GlobalColors.primaryColor,
                dotColor: ColorUtils.getAlternateColor(cntext),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildTopicHeader(BuildContext cntext) {
    return BlocBuilder<TopicDetailsBloc, TopicDetailsState>(
      builder: (_, state) {
        final topic = state.data.topic;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          topic?.title ?? '',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
                          ),
                        ),
                        const Gap(8),
                        IntrinsicHeight(
                          child: Row(
                            children: [
                              CircularAvatar(
                                url: topic?.user?.image ?? '',
                                size: 40,
                              ),
                              const Gap(16),
                              Text(
                                topic?.user?.name ?? '',
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              const VerticalDivider(
                                width: 20,
                                thickness: 2,
                              ),
                              Text(
                                "${topic?.vocabularies?.length} ${'vocabularies'.tr}",
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (topic?.isDownloaded == false ||
                          topic?.isDownloaded == null) {
                        context.read<TopicDetailsBloc>().add(
                              TopicDetailsEvent.downloadTopicToLocal(
                                topic: topic!,
                                userId: state.data.userId!,
                              ),
                            );
                      }
                    },
                    icon: Icon(
                      topic?.isDownloaded == true
                          ? Icons.check_circle_outline
                          : Icons.download_rounded,
                      size: 30,
                      color: GlobalColors.primaryColor,
                    ),
                  ),
                ],
              ),
              const Gap(10),
              Text(
                topic?.description ?? '',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLearningMethods(BuildContext cntext) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<TopicDetailsBloc, TopicDetailsState>(
        builder: (_, state) {
          final favoriteVocabularies = state.data.favoriteVocabularies;
          final isStudyAll = state.data.learnAll;
          return Column(
            children: [
              TouchableOpacity(
                color: GlobalColors.secondaryColor.withOpacity(0.2),
                onPressed: () async {
                  await navigator?.pushNamed(
                    RouteGenerator.learningFlashcard,
                    arguments: {
                      'TOPIC': state.data.topic,
                      'VOCABULARIES': favoriteVocabularies.isEmpty
                          ? state.data.topic?.vocabularies
                          : isStudyAll
                              ? state.data.topic?.vocabularies
                              : favoriteVocabularies
                    },
                  ).whenComplete(
                    () => cntext.read<TopicDetailsBloc>().add(
                          GetTopicDetails(
                            topicId: state.data.topic!.id!,
                            userId: state.data.userId!,
                          ),
                        ),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SvgPicture.asset(
                      'assets/images/flashcard_icon.svg',
                      colorFilter: const ColorFilter.mode(
                        GlobalColors.primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    const Gap(16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'flashcards'.tr,
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          const Gap(10),
                          Text(
                            'learn_by_flashcards_desc'.tr,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(10),
              TouchableOpacity(
                color: GlobalColors.secondaryColor.withOpacity(0.2),
                onPressed: () async {
                  await navigator?.pushNamed(
                    RouteGenerator.learningQuiz,
                    arguments: {
                      'TOPIC': state.data.topic,
                      'VOCABULARIES': favoriteVocabularies.isEmpty
                          ? state.data.topic?.vocabularies
                          : isStudyAll
                              ? state.data.topic?.vocabularies
                              : favoriteVocabularies,
                    },
                  ).whenComplete(
                    () => cntext.read<TopicDetailsBloc>().add(
                          GetTopicDetails(
                            topicId: state.data.topic!.id!,
                            userId: state.data.userId!,
                          ),
                        ),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SvgPicture.asset(
                      'assets/images/quiz_icon.svg',
                      colorFilter: const ColorFilter.mode(
                        GlobalColors.primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    const Gap(16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'quiz'.tr,
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          const Gap(10),
                          Text(
                            'learn_by_quiz_desc'.tr,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(10),
              TouchableOpacity(
                color: GlobalColors.secondaryColor.withOpacity(0.2),
                onPressed: () async {
                  await navigator?.pushNamed(
                    RouteGenerator.learningTyping,
                    arguments: {
                      'TOPIC': state.data.topic,
                      'VOCABULARIES': favoriteVocabularies.isEmpty
                          ? state.data.topic?.vocabularies
                          : isStudyAll
                              ? state.data.topic?.vocabularies
                              : favoriteVocabularies,
                    },
                  ).whenComplete(
                    () => cntext.read<TopicDetailsBloc>().add(
                          GetTopicDetails(
                            topicId: state.data.topic!.id!,
                            userId: state.data.userId!,
                          ),
                        ),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SvgPicture.asset(
                      'assets/images/typing_icon.svg',
                      colorFilter: const ColorFilter.mode(
                        GlobalColors.primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    const Gap(16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'typing'.tr,
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          const Gap(10),
                          Text(
                            'learn_by_typing_desc'.tr,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(10),
              TouchableOpacity(
                color: GlobalColors.secondaryColor.withOpacity(0.2),
                onPressed: () async {
                  await navigator?.pushNamed(
                    RouteGenerator.learningMatching,
                    arguments: {
                      'TOPIC': state.data.topic,
                      'VOCABULARIES': favoriteVocabularies.isEmpty
                          ? state.data.topic?.vocabularies
                          : isStudyAll
                              ? state.data.topic?.vocabularies
                              : favoriteVocabularies
                    },
                  ).whenComplete(
                    () => cntext.read<TopicDetailsBloc>().add(
                          GetTopicDetails(
                            topicId: state.data.topic!.id!,
                            userId: state.data.userId!,
                          ),
                        ),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SvgPicture.asset(
                      'assets/images/matching_icon.svg',
                      colorFilter: const ColorFilter.mode(
                        GlobalColors.primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    const Gap(16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'matching'.tr,
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          const Gap(10),
                          Text(
                            'learn_by_matching_desc'.tr,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (favoriteVocabularies.length > 1) ...[
                const Gap(10),
                _buildChooseVocabulariesNumber(
                  isStudyAll,
                  favoriteVocabularies.length,
                  () {
                    context.read<TopicDetailsBloc>().add(
                          const ToggleStudyAll(studyAll: true),
                        );
                  },
                  () {
                    context.read<TopicDetailsBloc>().add(
                          const ToggleStudyAll(studyAll: false),
                        );
                  },
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildChooseVocabulariesNumber(
    bool isStudyAll,
    int favorite,
    VoidCallback onStudyAllPressed,
    VoidCallback onStudyFavoritePressed,
  ) {
    return Container(
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: GlobalColors.primaryColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onStudyAllPressed,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(10),
                  ),
                  color: isStudyAll
                      ? GlobalColors.primaryColor
                      : Colors.transparent,
                ),
                child: Text(
                  'study_all'.tr,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    color:
                        isStudyAll ? Colors.white : GlobalColors.primaryColor,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: onStudyFavoritePressed,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(10),
                  ),
                  color: !isStudyAll
                      ? GlobalColors.primaryColor
                      : Colors.transparent,
                ),
                child: Text(
                  '${'study'.tr} $favorite ${'vocabularies'.tr}'.tr,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    color:
                        !isStudyAll ? Colors.white : GlobalColors.primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVocabulariesList(BuildContext cntext) {
    return BlocBuilder<TopicDetailsBloc, TopicDetailsState>(
        builder: (_, state) {
      final topic = state.data.topic;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'cards'.tr,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const Gap(10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: topic?.vocabularies?.length ?? 0,
              itemBuilder: (_, index) {
                final vocabulary = topic?.vocabularies?[index];
                final isSpeaking = state.data.vocabSpeakingIndex == index;
                final isTermSpeaking = state.data.isTermSpeaking;
                final isDefinitionSpeaking = state.data.isDefinitionSpeaking;
                final isFavorited = state.data.favoriteVocabularies
                    .any((element) => element.id == vocabulary?.id);
                final learningStatistics =
                    state.data.vocabularyStatistics.firstWhereOrNull(
                  (element) => element.vocabulary?.id == vocabulary?.id,
                );
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: CardItem(
                    onFavoritePressed: () =>
                        favoriteVocabulary(vocabulary!.id!),
                    isFavorite: isFavorited,
                    isTermSpeaking: isSpeaking && isTermSpeaking,
                    isDefinitionSpeaking: isSpeaking && isDefinitionSpeaking,
                    term: vocabulary?.term ?? '',
                    definition: vocabulary?.definition ?? '',
                    imageUrl: vocabulary?.image,
                    quizDeficit: learningStatistics == null
                        ? 0
                        : (learningStatistics.correctCount! -
                            learningStatistics.incorrectCount!),
                    onTermPressed: () {
                      if (state.data.vocabSpeakingIndex == -1) {
                        onTermPressed(vocabulary!, index);
                      }
                    },
                    onDefinitionPressed: () {
                      if (state.data.vocabSpeakingIndex == -1) {
                        onDefinitionPressed(vocabulary!, index);
                      }
                    },
                    onTtsPressed: () {
                      if (state.data.vocabSpeakingIndex == -1) {
                        onTtsPressed(vocabulary!, index);
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }

  Widget _buildPendingTopicPage(
      addTopicBloc.AddTopicBloc? pendingAddTopicBloc, BuildContext cntext) {
    return BlocBuilder<addTopicBloc.AddTopicBloc, addTopicBloc.AddTopicState>(
      bloc: pendingAddTopicBloc,
      builder: (_, currentState) {
        if (currentState is addTopicBloc.AddTopicLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (currentState is addTopicBloc.AddTopicSuccess ||
            currentState is addTopicBloc.UpdateTopicSuccess) {
          return SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        final topicDetailsBloc =
                            cntext.read<TopicDetailsBloc>();
                        final topic = topicDetailsBloc.state.data.topic;
                        final userId = topicDetailsBloc.state.data.userId;
                        cntext.read<TopicDetailsBloc>().add(
                              const DeletePendingTopicBloc(),
                            );
                        cntext.read<TopicDetailsBloc>().add(
                              GetTopicDetails(
                                topicId: topic!.id!,
                                userId: userId!,
                              ),
                            );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.check_circle_outline,
                              color: GlobalColors.primaryColor,
                              size: 100,
                            ),
                            const Gap(10),
                            Text(
                              'topic_updated_success'.tr,
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (currentState is addTopicBloc.AddTopicError ||
            currentState is addTopicBloc.UpdateTopicError) {
          SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        navigator?.pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.close,
                              color: GlobalColors.orangeColor,
                              size: 100,
                            ),
                            const Gap(10),
                            Text(
                              'topic_updated_failed'.tr,
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: GlobalColors.orangeColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildExportToCsvButton(BuildContext cntext) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          cntext.read<TopicDetailsBloc>().add(const ExportToCsv());
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: GlobalColors.primaryColor,
              width: 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Text(
            'export_to_csv'.tr,
            style: GoogleFonts.outfit(
              fontSize: 16,
              color: GlobalColors.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
