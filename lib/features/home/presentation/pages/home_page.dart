import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:final_flashcard/configs/common/global_constants.dart';
import 'package:final_flashcard/configs/common/widgets/home_menu_item.dart';
import 'package:final_flashcard/configs/routes/route_generator.dart';
import 'package:final_flashcard/features/home/presentation/bloc/home_bloc.dart';
import 'package:final_flashcard/features/home/presentation/widgets/home_topic_item.dart';
import 'package:final_flashcard/features/home/presentation/widgets/search_button.dart';
import 'package:final_flashcard/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:final_flashcard/features/search/presentation/bloc/search_bloc.dart';
import 'package:final_flashcard/features/topic/domain/entities/topic.dart';
import 'package:final_flashcard/features/topic/presentation/bloc/add_topic_bloc/add_topic_bloc.dart';
import 'package:final_flashcard/features/topic/presentation/bloc/topic/topic_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int _hourOfDay = DateTime.now().hour;
  String _greetingsString = '';
  final PageController _pageController = PageController(
    viewportFraction: 0.95,
  );
  final PageController _checkoutPageController = PageController(
    viewportFraction: 0.95,
  );

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
  void initState() {
    super.initState();
    if (_hourOfDay < 12) {
      _greetingsString = 'good_morning'.tr;
    } else if (_hourOfDay < 17) {
      _greetingsString = 'good_afternoon'.tr;
    } else {
      _greetingsString = 'good_evening'.tr;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _checkoutPageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.primaryColor,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext cntext) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<TopicBloc>().add(
                const GetTopics(),
              );
          context.read<SearchBloc>().add(
                const FetchSearchesTopics(),
              );
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _greetingsString,
                          style: GoogleFonts.outfit(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        BlocBuilder<ProfileBloc, ProfileState>(
                          builder: (context, state) {
                            return Text(
                              state.data.profile?.name ?? 'loading'.tr,
                              style: GoogleFonts.outfit(
                                fontSize: 25,
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        FontAwesomeIcons.solidBell,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: const EdgeInsets.only(top: 40),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: ColorUtils.getPrimaryBackgroundColor(context),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(40),
                        ),
                      ),
                      child: Column(
                        children: [
                          const Gap(
                            50,
                          ),
                          const Icon(
                            FontAwesomeIcons.medal,
                            color: Color(0XFFF0B44F),
                            size: 30,
                          ),
                          Column(
                            children: [
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: GoogleFonts.outfit(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                    color:
                                        ColorUtils.getPrimaryTextColor(context),
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "${'embrace_learning_for'.tr}\n",
                                    ),
                                    TextSpan(
                                      text: 'growth'.tr,
                                      style: GoogleFonts.outfit(
                                        color: GlobalColors.primaryColor,
                                      ),
                                    ),
                                    TextSpan(
                                      text: " ${'and'.tr} ",
                                    ),
                                    TextSpan(
                                      text: 'possibilities'.tr,
                                      style: GoogleFonts.outfit(
                                        color: GlobalColors.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Gap(20),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: SearchButton(
                                  onTap: () {
                                    context.read<HomeBloc>().add(
                                          const ChangeNavIndexEvent(1),
                                        );
                                  },
                                ),
                              ),
                              const Gap(20),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: HomeMenuItem(
                                        title: 'topics'.tr,
                                        imageAsset:
                                            'assets/images/flashcard_icon.png',
                                        onTap: () {
                                          context.read<HomeBloc>().add(
                                                const ChangeNavIndexEvent(2),
                                              );
                                          context.read<HomeBloc>().add(
                                                const ChangeLibraryIndexEvent(
                                                    0),
                                              );
                                        },
                                      ),
                                    ),
                                    const Gap(10),
                                    Expanded(
                                      child: HomeMenuItem(
                                        title: 'folders'.tr,
                                        imageAsset:
                                            'assets/images/folder_icon.png',
                                        onTap: () {
                                          context.read<HomeBloc>().add(
                                                const ChangeNavIndexEvent(2),
                                              );
                                          context.read<HomeBloc>().add(
                                                const ChangeLibraryIndexEvent(
                                                    1),
                                              );
                                        },
                                      ),
                                    ),
                                    const Gap(10),
                                    Expanded(
                                      child: HomeMenuItem(
                                        title: 'achievements'.tr,
                                        imageAsset:
                                            'assets/images/achievement_icon.png',
                                        onTap: () {},
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Gap(20),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Text(
                                    'recent_topics'.tr,
                                    style: GoogleFonts.outfit(
                                      fontSize: 20,
                                      color: ColorUtils.getPrimaryTextColor(
                                          context),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              const Gap(20),
                              AspectRatio(
                                aspectRatio: 2,
                                child: BlocBuilder<TopicBloc, TopicState>(
                                  builder: (context, state) {
                                    final pendingBloc =
                                        state.data.addTopicBlocs;
                                    final pendingBlocTopicsIds = pendingBloc
                                        .where((e) =>
                                            e.state.data.currentTopic != null)
                                        .map((e) =>
                                            e.state.data.currentTopic!.id!)
                                        .toList();
                                    final topicList = state.data.topics
                                        .where(
                                          (e) => !pendingBlocTopicsIds
                                              .contains(e.id),
                                        )
                                        .toList();

                                    return topicList.isEmpty &&
                                            pendingBloc.isEmpty
                                        ? Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/images/flashcard.png',
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.3,
                                                fit: BoxFit.cover,
                                              ),
                                              const Gap(10),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16),
                                                child: Text(
                                                  'no_topic'.tr,
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.outfit(
                                                    fontSize: 24,
                                                    color: GlobalColors
                                                        .primaryColor,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : PageView.builder(
                                            itemCount: pendingBloc.length +
                                                topicList.length,
                                            controller: _pageController,
                                            itemBuilder: (context, index) {
                                              if (index < pendingBloc.length) {
                                                return _buildPendingTopic(
                                                  pendingBloc[index],
                                                );
                                              }
                                              final topic = topicList[
                                                  index - pendingBloc.length];
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                ),
                                                child: HomeTopicItem(
                                                  topic: topic,
                                                  onTap: () =>
                                                      navigateToTopicDetails(
                                                    topic,
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                  },
                                ),
                              ),
                              const Gap(20),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Text(
                                    'checkout_some_topics'.tr,
                                    style: GoogleFonts.outfit(
                                      fontSize: 20,
                                      color: ColorUtils.getPrimaryTextColor(
                                          context),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              const Gap(20),
                              _buildCheckoutTopics(),
                              const Gap(40),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, state) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: state.data.profile?.image != null
                            ? Container(
                                color: Colors.black,
                                child: CachedNetworkImage(
                                  imageUrl: state.data.profile?.image ??
                                      GlobalConstants.kDefaultAvatarUrl,
                                  fit: BoxFit.cover,
                                  width: 80,
                                  height: 80,
                                ),
                              )
                            : Image.asset(
                                'assets/images/app_icon.png',
                                fit: BoxFit.cover,
                                width: 80,
                                height: 80,
                              ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPendingTopic(AddTopicBloc addTopicBloc) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: BlocBuilder<AddTopicBloc, AddTopicState>(
        bloc: addTopicBloc,
        builder: (context, state) {
          if (state is AddTopicLoading) {
            return _buildTopicStatus();
          } else if (state is AddTopicSuccess || state is UpdateTopicSuccess) {
            return GestureDetector(
              onTap: () {
                context.read<TopicBloc>().add(
                      RemovePendingBloc(addTopicBloc),
                    );
                context.read<TopicBloc>().add(
                      const GetTopics(),
                    );
                addTopicBloc.close();
              },
              child: _buildTopicStatus(
                icon: FontAwesomeIcons.check,
              ),
            );
          } else if (state is AddTopicError) {
            return GestureDetector(
              onTap: () {
                context.read<TopicBloc>().add(
                      RemovePendingBloc(addTopicBloc),
                    );
                context.read<TopicBloc>().add(
                      const GetTopics(),
                    );
                addTopicBloc.close();
              },
              child: _buildTopicStatus(
                icon: FontAwesomeIcons.xmark,
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildTopicStatus({
    IconData? icon,
  }) {
    return Material(
      color: GlobalColors.primaryColor.withOpacity(0.2),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(10),
        child: icon == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Center(
                child: Icon(
                  icon,
                  size: 60,
                ),
              ),
      ),
    );
  }

  Widget _buildCheckoutTopics() {
    return AspectRatio(
      aspectRatio: 2,
      child: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          final originalSearchResults = state.data.originalTopics;

          return originalSearchResults.isEmpty
              ? Column(
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
                )
              : PageView.builder(
                  itemCount: originalSearchResults.length,
                  controller: _checkoutPageController,
                  itemBuilder: (_, index) {
                    final topic = originalSearchResults[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: HomeTopicItem(
                        topic: topic,
                        onTap: () => navigateToTopicDetails(
                          topic,
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
