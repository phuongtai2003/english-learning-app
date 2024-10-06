import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:final_flashcard/configs/common/global_constants.dart';
import 'package:final_flashcard/configs/common/widgets/custom_dropdown_button.dart';
import 'package:final_flashcard/configs/common/widgets/custom_main_switch.dart';
import 'package:final_flashcard/configs/common/widgets/three_dimensional_button.dart';
import 'package:final_flashcard/configs/common/widgets/touchable_opacity.dart';
import 'package:final_flashcard/configs/routes/route_generator.dart';
import 'package:final_flashcard/core/data/enums.dart';
import 'package:final_flashcard/core/utils/ui_helpers.dart';
import 'package:final_flashcard/features/topic/domain/entities/topic.dart';
import 'package:final_flashcard/features/topic/presentation/bloc/add_topic_bloc/add_topic_bloc.dart';
import 'package:final_flashcard/features/topic/presentation/widgets/add_more_widget.dart';
import 'package:final_flashcard/features/topic/presentation/widgets/add_topic_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AddTopicPage extends StatefulWidget {
  const AddTopicPage({super.key, this.topic});
  final Topic? topic;

  @override
  State<AddTopicPage> createState() => _AddTopicPageState();
}

class _AddTopicPageState extends State<AddTopicPage> {
  final TextEditingController _topicNameController = TextEditingController();
  final TextEditingController _topicDescriptionController =
      TextEditingController();
  final _flashCardController = PageController(
    viewportFraction: 1,
  );

  void _showConfirmDeleteTopic() {
    navigator!.pop();
    UIHelpers.showAwesomeDialog(
      context: context,
      title: 'confirmation'.tr,
      message: 'delete_topic_confirm_msg'.tr,
      type: DialogType.warning,
      btnCancel: 'cancel'.tr,
      onCancelPressed: () {},
      onOkPressed: () {
        context.read<AddTopicBloc>().add(const AddTopicEvent.deleteTopic());
      },
    );
  }

  void _showTopicSettings() async {
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
        return BlocBuilder<AddTopicBloc, AddTopicState>(
            bloc: context.read<AddTopicBloc>(),
            builder: (__, state) {
              final size = MediaQuery.of(context).size;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Wrap(
                  children: [
                    Column(
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
                        const Gap(10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Text(
                                'term_language'.tr,
                                style: GoogleFonts.outfit(
                                  fontSize: 20,
                                  color:
                                      ColorUtils.getPrimaryTextColor(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomDropdownButton<String>(
                                  itemsList: GlobalConstants.topicLanguages.keys
                                      .toList(),
                                  dataMap: GlobalConstants.topicLanguages,
                                  value: context
                                      .read<AddTopicBloc>()
                                      .state
                                      .data
                                      .termLanguage,
                                  onChanged: (value) {
                                    if (value != null) {
                                      context.read<AddTopicBloc>().add(
                                            AddTopicEvent.changeTermLanguage(
                                                value),
                                          );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Text(
                                'definition_language'.tr,
                                style: GoogleFonts.outfit(
                                  fontSize: 20,
                                  color:
                                      ColorUtils.getPrimaryTextColor(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomDropdownButton<String>(
                                  itemsList: GlobalConstants.topicLanguages.keys
                                      .toList(),
                                  dataMap: GlobalConstants.topicLanguages,
                                  value: context
                                      .read<AddTopicBloc>()
                                      .state
                                      .data
                                      .definitionLanguage,
                                  onChanged: (value) {
                                    context.read<AddTopicBloc>().add(
                                          AddTopicEvent
                                              .changeDefinitionLanguage(value!),
                                        );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (state.data.isNewTopic) ...[
                          const Gap(16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Text(
                                  'public'.tr,
                                  style: GoogleFonts.outfit(
                                    fontSize: 20,
                                    color:
                                        ColorUtils.getPrimaryTextColor(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Gap(10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: GlobalColors.primaryColor,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 6)
                                  .copyWith(left: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      'public_topic'.tr,
                                      style: GoogleFonts.outfit(
                                        fontSize: 16,
                                        color: ColorUtils.getPrimaryTextColor(
                                            context),
                                      ),
                                    ),
                                  ),
                                  CustomMainSwitch(
                                    onChanged: (value) {
                                      context.read<AddTopicBloc>().add(
                                            AddTopicEvent.changeTopicPublic(
                                              value,
                                            ),
                                          );
                                    },
                                    value: state.data.isTopicPublic,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        if (!state.data.isNewTopic) ...[
                          const Gap(16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Material(
                              color: ColorUtils.getSecondaryBackgroundColor(
                                  context),
                              borderRadius: BorderRadius.circular(16),
                              child: InkWell(
                                onTap: _showConfirmDeleteTopic,
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(16),
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 16,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      const Icon(
                                        Icons.delete,
                                        size: 20,
                                        color: GlobalColors.primaryColor,
                                      ),
                                      const Gap(10),
                                      Text(
                                        'delete_topic'.tr,
                                        style: GoogleFonts.outfit(
                                          fontSize: 20,
                                          color: GlobalColors.primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Gap(16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Material(
                              color: ColorUtils.getSecondaryBackgroundColor(
                                  context),
                              borderRadius: BorderRadius.circular(16),
                              child: InkWell(
                                onTap: () async {
                                  await navigator!.pushNamed(
                                    RouteGenerator.addFolderToTopic,
                                    arguments: {
                                      'TOPIC': widget.topic,
                                    },
                                  );
                                },
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(16),
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 16,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      const Icon(
                                        Icons.folder_outlined,
                                        size: 20,
                                        color: GlobalColors.primaryColor,
                                      ),
                                      const Gap(10),
                                      Text(
                                        'add_topic_to_folder'.tr,
                                        style: GoogleFonts.outfit(
                                          fontSize: 20,
                                          color: GlobalColors.primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              );
            });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _topicNameController.addListener(() {
      setState(() {});
    });
    _topicDescriptionController.addListener(() {
      setState(() {});
    });
    if (widget.topic == null) {
      context.read<AddTopicBloc>().add(const AddTopicEvent.addFlashcard());
      context.read<AddTopicBloc>().add(const AddTopicEvent.addFlashcard());
    } else {
      _topicNameController.text = widget.topic!.title ?? '';
      _topicDescriptionController.text = widget.topic!.description ?? '';
      context.read<AddTopicBloc>().add(
            AddTopicEvent.loadedTopic(widget.topic!),
          );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _topicNameController.dispose();
    _topicDescriptionController.dispose();
    _flashCardController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: GlobalColors.primaryColor,
          ),
          onPressed: () {
            context.read<AddTopicBloc>().close();
            navigator!.pop();
          },
        ),
        title: Text(
          'add_topic'.tr,
          style: GoogleFonts.outfit(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: GlobalColors.primaryColor,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              FontAwesomeIcons.gear,
              color: GlobalColors.primaryColor,
            ),
            onPressed: _showTopicSettings,
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocConsumer<AddTopicBloc, AddTopicState>(
        listener: (context, state) {
      if (state is AddTopicAddFlashcard) {
        if (_flashCardController.hasClients) {
          _flashCardController.jumpToPage(state.data.flashcardIndex);
        }
      }
      if (state is DeleteTopicError) {
        UIHelpers.showAwesomeDialog(
          context: context,
          title: 'error'.tr,
          message: state.data.error.tr,
          type: DialogType.error,
        );
      } else if (state is DeleteTopicSuccess) {
        navigator!.pop(
          context.read<AddTopicBloc>(),
        );
      }
    }, builder: (context, state) {
      final flashCardWidgets = state.data.flashcardsList;
      final currentIndex = state.data.flashcardIndex + 1;
      if (state is AddTopicLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is DeleteTopicSuccess) {
        return const SizedBox();
      }
      return SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ).copyWith(top: 16),
                child: AddTopicTextFormField(
                  labelText: 'topic_name'.tr,
                  textEditingController: _topicNameController,
                  icon: _topicNameController.text.isEmpty
                      ? null
                      : Icons.close_rounded,
                  onIconTap: () {
                    _topicNameController.clear();
                  },
                ),
              ),
              const Gap(16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AddTopicTextFormField(
                  labelText: 'topic_description'.tr,
                  textEditingController: _topicDescriptionController,
                  icon: _topicDescriptionController.text.isEmpty
                      ? null
                      : Icons.close_rounded,
                  onIconTap: () {
                    _topicDescriptionController.clear();
                  },
                  maxLines: 2,
                  keyboardType: TextInputType.multiline,
                ),
              ),
              const Gap(16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    TouchableOpacity(
                      color: Colors.transparent,
                      borderColor: GlobalColors.primaryColor,
                      onPressed: () {
                        context.read<AddTopicBloc>().add(
                              const ImportCsvFileEvent(),
                            );
                      },
                      child: Text(
                        'import_csv'.tr,
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          color: GlobalColors.primaryColor,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        context.read<AddTopicBloc>().add(
                              const AddTopicEvent.addFlashcard(),
                            );
                      },
                      icon: const Icon(
                        FontAwesomeIcons.plus,
                        color: GlobalColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(8),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: PageView.builder(
                  onPageChanged: (index) {
                    if (index != flashCardWidgets.length) {
                      context.read<AddTopicBloc>().add(
                            AddTopicEvent.changeFlashcardIndex(index),
                          );
                    }
                  },
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    if (index == flashCardWidgets.length) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ).copyWith(bottom: 20),
                        child: AddMoreWidget(
                          onPressed: () {
                            context.read<AddTopicBloc>().add(
                                  const AddTopicEvent.addFlashcard(),
                                );
                          },
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ).copyWith(bottom: 20),
                      child: flashCardWidgets[index],
                    );
                  },
                  itemCount: flashCardWidgets.length + 1,
                  controller: _flashCardController,
                ),
              ),
              const Gap(10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (_flashCardController.page != 0) {
                          context.read<AddTopicBloc>().add(
                                AddTopicEvent.changeFlashcardIndex(
                                  _flashCardController.page!.toInt() - 1,
                                ),
                              );
                        }
                      },
                      icon: const Icon(
                        FontAwesomeIcons.angleLeft,
                        color: GlobalColors.primaryColor,
                      ),
                    ),
                    Text(
                      '${UIHelpers.formatNumber(currentIndex)}/${UIHelpers.formatNumber(flashCardWidgets.length)}',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: GlobalColors.primaryColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (_flashCardController.page !=
                            flashCardWidgets.length - 1) {
                          context.read<AddTopicBloc>().add(
                                AddTopicEvent.changeFlashcardIndex(
                                  _flashCardController.page!.toInt() + 1,
                                ),
                              );
                        }
                      },
                      icon: const Icon(
                        FontAwesomeIcons.angleRight,
                        color: GlobalColors.primaryColor,
                      ),
                    )
                  ],
                ),
              ),
              const Gap(10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16)
                    .copyWith(bottom: 16),
                child: ThreeDimensionalButton(
                  onPressed: () {
                    if (state.data.isNewTopic) {
                      _validateInput(
                        _topicNameController.text,
                        _topicDescriptionController.text,
                        flashCardWidgets
                            .map((e) => e.cardTermController)
                            .toList(),
                        flashCardWidgets
                            .map((e) => e.cardDefinitionController)
                            .toList(),
                      );
                    } else {
                      _validateInputToUpdate(
                        _topicNameController.text,
                        _topicDescriptionController.text,
                        flashCardWidgets
                            .map((e) => e.cardTermController)
                            .toList(),
                        flashCardWidgets
                            .map((e) => e.cardDefinitionController)
                            .toList(),
                      );
                    }
                  },
                  buttonText: 'save'.tr.toUpperCase(),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _validateInput(
    String topicName,
    String topicDescription,
    List<TextEditingController> flashCardTerms,
    List<TextEditingController> flashCardDefinitions,
  ) {
    if (topicName.isEmpty || topicDescription.isEmpty) {
      UIHelpers.showSnackBar(
        context,
        'enter_topic_name'.tr,
        SnackBarType.warning,
      );
      return;
    }

    if (flashCardTerms.length < 2 || flashCardDefinitions.length < 2) {
      UIHelpers.showSnackBar(
        context,
        'add_at_least_two_flashcards'.tr,
        SnackBarType.warning,
      );
      return;
    }

    for (final flashCardTerm in flashCardTerms) {
      if (flashCardTerm.text.isEmpty) {
        UIHelpers.showSnackBar(
          context,
          'enter_all_terms'.tr,
          SnackBarType.warning,
        );
        return;
      }
    }

    for (final flashCardDefinition in flashCardDefinitions) {
      if (flashCardDefinition.text.isEmpty) {
        UIHelpers.showSnackBar(
          context,
          'enter_all_definitions'.tr,
          SnackBarType.warning,
        );
        return;
      }
    }

    context.read<AddTopicBloc>().add(
          AddTopicEvent.addTopic(
            topicName,
            topicDescription,
          ),
        );
    navigator!.pop(context.read<AddTopicBloc>());
  }

  void _validateInputToUpdate(
    String topicName,
    String topicDescription,
    List<TextEditingController> flashCardTerms,
    List<TextEditingController> flashCardDefinitions,
  ) {
    if (topicName.isEmpty || topicDescription.isEmpty) {
      UIHelpers.showSnackBar(
        context,
        'enter_topic_name'.tr,
        SnackBarType.warning,
      );
      return;
    }

    if (flashCardTerms.length < 2 || flashCardDefinitions.length < 2) {
      UIHelpers.showSnackBar(
        context,
        'add_at_least_two_flashcards'.tr,
        SnackBarType.warning,
      );
      return;
    }

    for (final flashCardTerm in flashCardTerms) {
      if (flashCardTerm.text.isEmpty) {
        UIHelpers.showSnackBar(
          context,
          'enter_all_terms'.tr,
          SnackBarType.warning,
        );
        return;
      }
    }

    for (final flashCardDefinition in flashCardDefinitions) {
      if (flashCardDefinition.text.isEmpty) {
        UIHelpers.showSnackBar(
          context,
          'enter_all_definitions'.tr,
          SnackBarType.warning,
        );
        return;
      }
    }

    context.read<AddTopicBloc>().add(
          AddTopicEvent.updateTopic(
            topicName: topicName,
            topicDescription: topicDescription,
          ),
        );
    navigator!.pop(context.read<AddTopicBloc>());
  }
}
