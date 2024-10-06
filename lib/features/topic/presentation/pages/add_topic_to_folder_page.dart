import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:final_flashcard/configs/common/widgets/three_dimensional_button.dart';
import 'package:final_flashcard/configs/routes/route_generator.dart';
import 'package:final_flashcard/core/utils/ui_helpers.dart';
import 'package:final_flashcard/di/di_config.dart';
import 'package:final_flashcard/features/topic/presentation/bloc/add_topic_bloc/add_topic_bloc.dart';
import 'package:final_flashcard/features/topic/presentation/bloc/add_topic_folder_bloc/add_topic_folder_bloc.dart';
import 'package:final_flashcard/features/topic/presentation/widgets/library_topic_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AddTopicToFolderPage extends StatelessWidget {
  const AddTopicToFolderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: GlobalColors.primaryColor,
          ),
          onPressed: () {
            navigator!.pop();
          },
        ),
        title: Text(
          'add_topic_to_folder'.tr,
          style: GoogleFonts.outfit(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: GlobalColors.primaryColor,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.check,
              color: GlobalColors.primaryColor,
            ),
            onPressed: () {
              context.read<AddTopicFolderBloc>().add(
                    const AddTopicsToFolder(),
                  );
            },
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext cntext) {
    return SafeArea(
      child: BlocConsumer<AddTopicFolderBloc, AddTopicFolderState>(
        listener: (context, state) {
          if (state is AddTopicsSuccess) {
            UIHelpers.showAwesomeDialog(
              context: context,
              title: 'success'.tr,
              message: 'added_topics_success'.tr,
              type: DialogType.success,
            );
          }
        },
        builder: (context, state) {
          if (state is AddTopicFolderLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: GlobalColors.primaryColor,
              ),
            );
          } else if (state is AddTopicFolderLoaded ||
              state is AddTopicsSuccess) {
            final availableTopics = state.data.availableTopics;
            final selectedTopics = state.data.selectedTopics;
            return availableTopics.isEmpty && selectedTopics.isEmpty
                ? SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Image.asset(
                          'assets/images/flashcard.png',
                          width: MediaQuery.of(context).size.width * 0.3,
                        ),
                        const Gap(16),
                        Text(
                          'no_topic'.tr,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.outfit(
                            color: ColorUtils.getPrimaryTextColor(context),
                            fontSize: 30,
                          ),
                        ),
                        const Gap(16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: ThreeDimensionalButton(
                            buttonText: 'add_topic'.tr.toUpperCase(),
                            onPressed: () async {
                              final bloc =
                                  await navigator!.pushNamed<AddTopicBloc>(
                                RouteGenerator.addTopic,
                                arguments: {
                                  'ADD_TOPIC_BLOC': AddTopicBloc(
                                    getIt.get(),
                                    getIt.get(),
                                    getIt.get(),
                                    getIt.get(),
                                  ),
                                },
                              );
                              if (bloc != null &&
                                  bloc.state is AddTopicLoading) {
                                bloc.stream.listen(
                                  (state) {
                                    if (state is AddTopicSuccess) {
                                      context.read<AddTopicFolderBloc>().add(
                                            GetAvailableTopics(
                                              context
                                                  .read<AddTopicFolderBloc>()
                                                  .state
                                                  .data
                                                  .folder!,
                                            ),
                                          );
                                      bloc.close();
                                    }
                                  },
                                );
                              } else if (bloc != null) {
                                bloc.close();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 24),
                    child: ListView.separated(
                      itemCount: availableTopics.length,
                      itemBuilder: (context, indext) {
                        final topic = availableTopics[indext];
                        return LibraryTopicItem(
                          onTap: () => context.read<AddTopicFolderBloc>().add(
                                AddTopicFolderEvent.triggerSelectTopic(topic),
                              ),
                          topic: topic,
                          allowedToEdit: false,
                          onEditPressed: () {},
                          isSelected: selectedTopics.contains(topic),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Gap(16);
                      },
                    ),
                  );
          } else {
            return Center(
              child: Text(
                state.data.error.tr,
                style: GoogleFonts.outfit(
                  color: ColorUtils.getPrimaryTextColor(context),
                  fontSize: 18,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
