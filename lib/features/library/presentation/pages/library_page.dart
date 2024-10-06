import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:final_flashcard/configs/routes/route_generator.dart';
import 'package:final_flashcard/di/di_config.dart';
import 'package:final_flashcard/features/folder/domain/entities/folder.dart';
import 'package:final_flashcard/features/folder/presentation/bloc/folder/folder_bloc.dart';
import 'package:final_flashcard/features/home/presentation/bloc/home_bloc.dart';
import 'package:final_flashcard/features/library/presentation/widgets/latest_reviewed_item.dart';
import 'package:final_flashcard/features/folder/presentation/widgets/library_folder_item.dart';
import 'package:final_flashcard/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:final_flashcard/features/topic/domain/entities/topic.dart';
import 'package:final_flashcard/features/topic/presentation/bloc/add_topic_bloc/add_topic_bloc.dart';
import 'package:final_flashcard/features/topic/presentation/widgets/library_topic_item.dart';
import 'package:final_flashcard/features/search/presentation/widgets/search_text_form_field.dart';
import 'package:final_flashcard/features/topic/presentation/bloc/topic/topic_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  void navigateToTopicDetails(Topic topic) async {
    final profileBloc = context.read<ProfileBloc>();
    final userId = profileBloc.state.data.profile?.id;
    await navigator?.pushNamed(
      RouteGenerator.topicDetails,
      arguments: {
        'TOPIC_ID': topic.id,
        'TERM_LANGUAGE': topic.termLocale,
        'DEFINITION_LANGUAGE': topic.definitionLocale,
        'USER_ID': userId,
      },
    ).whenComplete(() => context.read<TopicBloc>().add(const GetTopics()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 20,
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/app_icon.png',
                  width: 60,
                  height: 60,
                ),
                const Gap(10),
                Text(
                  'Leaf',
                  style: GoogleFonts.outfit(
                    color: GlobalColors.primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 30,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    context.read<TopicBloc>().add(const GetTopics());
                    context.read<FolderBloc>().add(const LoadFolder());
                  },
                  icon: const Icon(
                    FontAwesomeIcons.arrowsRotate,
                    color: GlobalColors.primaryColor,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SearchTextFormField(
              textEditingController: TextEditingController(),
              hint: 'search_now'.tr,
            ),
          ),
          const Gap(20),
          BlocBuilder<TopicBloc, TopicState>(builder: (_, state) {
            final recentlyLearnedTopic =
                state.data.recentTopicLearningStatisticsModel;
            final recentlyVocabulariesStatistics =
                state.data.recentVocabularyStatistics;
            if (recentlyLearnedTopic != null) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: LatestReviewedItem(
                  recentTopicTitle: recentlyLearnedTopic.topic?.title ?? '',
                  learnedTerms: recentlyVocabulariesStatistics.length,
                  onPressed: () {
                    navigateToTopicDetails(recentlyLearnedTopic.topic!);
                  },
                  percentage: recentlyLearnedTopic.percentageCompleted ?? 0.0,
                ),
              );
            }
            return const SizedBox.shrink();
          }),
          const Gap(8),
          BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
            return Expanded(
              child: DefaultTabController(
                length: 2,
                initialIndex: state.data.currentLibraryIndex,
                child: Column(
                  children: [
                    TabBar(
                      automaticIndicatorColorAdjustment: true,
                      tabAlignment: TabAlignment.fill,
                      indicatorSize: TabBarIndicatorSize.tab,
                      dragStartBehavior: DragStartBehavior.down,
                      tabs: [
                        Tab(
                          child: Text(
                            'topics'.tr,
                            style: GoogleFonts.outfit(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'folders'.tr,
                            style: GoogleFonts.outfit(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildTopics(context),
                          _buildFolders(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTopics(BuildContext cntext) {
    return BlocBuilder<TopicBloc, TopicState>(
      builder: (context, state) {
        if (state is TopicLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is TopicLoaded) {
          final topicList = state.data.topics;
          final topicLearningStatistics = state.data.topicLearningStatistics;
          final vocabularyStatistics = state.data.vocabularyStatistics;
          return topicList.isNotEmpty
              ? ListView.builder(
                  itemCount: topicList.length,
                  itemBuilder: (_, index) {
                    final currentUser =
                        cntext.read<ProfileBloc>().state.data.profile?.id;
                    final currentTopic = topicList[index];
                    final currentTopicLearningStatistics =
                        topicLearningStatistics[index];
                    final currentVocabularyStatistics =
                        vocabularyStatistics[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LibraryTopicItem(
                        topic: currentTopic,
                        topicLearningStatistics: currentTopicLearningStatistics,
                        vocabularyStatistics: currentVocabularyStatistics,
                        allowedToEdit: currentUser == currentTopic.user?.id,
                        onEditPressed: () {
                          _onEditTopicPressed(currentTopic, context);
                        },
                        onTap: () => navigateToTopicDetails(currentTopic),
                      ),
                    );
                  },
                )
              : Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/flashcard.png',
                      width: MediaQuery.of(context).size.width * 0.3,
                      fit: BoxFit.cover,
                    ),
                    const Gap(10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'no_topic'.tr,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 24,
                          color: GlobalColors.primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  void _onEditTopicPressed(Topic topic, BuildContext cntext) async {
    final res = await navigator!.pushNamed<AddTopicBloc>(
      RouteGenerator.addTopic,
      arguments: {
        'TOPIC': topic,
        'ADD_TOPIC_BLOC': AddTopicBloc(
          getIt.get(),
          getIt.get(),
          getIt.get(),
          getIt.get(),
        ),
      },
    ).whenComplete(
      () => cntext.read<TopicBloc>().add(const GetTopics()),
    );
    if (res != null && cntext.mounted) {
      _addPendingBloc(res, cntext);
    }
  }

  void _addPendingBloc(AddTopicBloc bloc, BuildContext cntext) {
    cntext.read<TopicBloc>().add(AddPendingBloc(bloc));
  }

  Widget _buildFolders(BuildContext context) {
    return BlocBuilder<FolderBloc, FolderState>(
      builder: (context, state) {
        if (state is FolderLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is FolderLoaded) {
          final folderList = state.data.folders;
          return folderList.isNotEmpty
              ? ListView.builder(
                  itemCount: folderList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LibraryFolderItem(
                        onTap: () => _onTapFolder(context, folderList[index]),
                        folder: folderList[index],
                      ),
                    );
                  },
                )
              : Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/empty_folder.png',
                      width: MediaQuery.of(context).size.width * 0.3,
                      fit: BoxFit.cover,
                    ),
                    const Gap(10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'no_folder'.tr,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 24,
                          color: GlobalColors.primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  void _onTapFolder(BuildContext context, Folder folder) async {
    await navigator!.pushNamed(
      RouteGenerator.folderDetail,
      arguments: {
        'FOLDER': folder,
      },
    ).whenComplete(
      () => context.read<FolderBloc>().add(
            const LoadFolder(),
          ),
    );
  }
}
