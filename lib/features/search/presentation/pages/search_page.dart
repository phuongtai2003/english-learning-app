import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:final_flashcard/configs/routes/route_generator.dart';
import 'package:final_flashcard/features/folder/presentation/bloc/folder/folder_bloc.dart';
import 'package:final_flashcard/features/home/presentation/widgets/home_topic_item.dart';
import 'package:final_flashcard/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:final_flashcard/features/search/presentation/bloc/search_bloc.dart';
import 'package:final_flashcard/features/search/presentation/widgets/search_text_form_field.dart';
import 'package:final_flashcard/features/topic/domain/entities/topic.dart';
import 'package:final_flashcard/features/topic/presentation/bloc/topic/topic_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    initController();
  }

  void initController() {
    _searchEditingController.addListener(
      () {
        if (_searchEditingController.text.isEmpty) {
          context.read<SearchBloc>().add(
                const ToggleFocusEvent(isFocus: false),
              );
        } else {
          context.read<SearchBloc>().add(
                const ToggleFocusEvent(isFocus: true),
              );
          context.read<SearchBloc>().add(
                QueryTopicsEvent(query: _searchEditingController.text),
              );
        }
      },
    );
  }

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
  void dispose() {
    super.dispose();
    _searchEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext cntext) {
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
                    cntext.read<TopicBloc>().add(const GetTopics());
                    cntext.read<FolderBloc>().add(const LoadFolder());
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
              textEditingController: _searchEditingController,
              hint: 'search_now'.tr,
            ),
          ),
          const Gap(10),
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (_, state) {
                if (state.data.isFocus) {
                  final filteredTopics = state.data.filteredTopics;
                  return ListView.builder(
                    itemCount: filteredTopics.length,
                    itemBuilder: (_, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: HomeTopicItem(
                          topic: filteredTopics[index],
                          onTap: () =>
                              navigateToTopicDetails(filteredTopics[index]),
                        ),
                      );
                    },
                  );
                }
                return Center(
                  child: Text(
                    'search_study_sets'.tr,
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: GlobalColors.primaryColor,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
