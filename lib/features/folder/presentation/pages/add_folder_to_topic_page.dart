import 'package:avatar_glow/avatar_glow.dart';
import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:final_flashcard/configs/common/widgets/custom_text_form_field.dart';
import 'package:final_flashcard/configs/common/widgets/three_dimensional_button.dart';
import 'package:final_flashcard/features/folder/presentation/bloc/folder_to_topic_bloc/folder_to_topic_bloc.dart';
import 'package:final_flashcard/features/folder/presentation/widgets/library_folder_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AddFolderToTopicPage extends StatefulWidget {
  const AddFolderToTopicPage({super.key});

  @override
  State<AddFolderToTopicPage> createState() => _AddFolderToTopicPageState();
}

class _AddFolderToTopicPageState extends State<AddFolderToTopicPage> {
  final _addFolderFormKey = GlobalKey<FormState>();
  final _folderTitleController = TextEditingController();
  final _folderDescriptionController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _folderTitleController.dispose();
    _folderDescriptionController.dispose();
  }

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
        backgroundColor: Colors.transparent,
        elevation: 0,
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
              context.read<FolderToTopicBloc>().add(
                    const AddFoldersToTopicEvent(),
                  );
            },
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext cnText) {
    return SafeArea(
      child: BlocBuilder<FolderToTopicBloc, FolderToTopicState>(
        builder: (context, state) {
          final folders = state.data.folders;
          final selectedFolders = state.data.selectedFolders;
          if (state is FolderToTopicLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: folders.isNotEmpty
                ? ListView.separated(
                    separatorBuilder: (context, index) => const Gap(16),
                    itemCount: folders.length + 1,
                    itemBuilder: (context, index) {
                      if (index == folders.length) {
                        return ThreeDimensionalButton(
                          onPressed: _showAddFolderDialog,
                          buttonText: 'add_folder'.tr,
                        );
                      }
                      return LibraryFolderItem(
                        isSelected: selectedFolders.contains(folders[index]),
                        onTap: () {
                          context.read<FolderToTopicBloc>().add(
                                TriggerFolderSelection(
                                  folder: folders[index],
                                ),
                              );
                        },
                        folder: folders[index],
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
                      ),
                      const Gap(16),
                      Text(
                        'no_folder'.tr,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          color: ColorUtils.getPrimaryTextColor(context),
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Gap(16),
                      ThreeDimensionalButton(
                        onPressed: _showAddFolderDialog,
                        buttonText: 'add_folder'.tr,
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }

  void _showAddFolderDialog() async {
    await showDialog(
      context: context,
      builder: (_) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: BlocBuilder<FolderToTopicBloc, FolderToTopicState>(
            bloc: context.read<FolderToTopicBloc>(),
            builder: (__, state) {
              if (state is FolderCreatedSuccessfully) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: GestureDetector(onTap: () {
                        navigator!.pop();
                      }),
                    ),
                    GestureDetector(
                      onTap: () {
                        navigator!.pop();
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color:
                              ColorUtils.getSecondaryBackgroundColor(context),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(
                              10,
                            ),
                          ),
                        ),
                        padding: const EdgeInsets.all(24).copyWith(top: 40),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AvatarGlow(
                              animate: true,
                              duration: const Duration(milliseconds: 1000),
                              repeat: true,
                              glowShape: BoxShape.circle,
                              glowCount: 3,
                              curve: Curves.easeInOut,
                              glowColor: GlobalColors.primaryColor,
                              glowRadiusFactor: 0.2,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: const BoxDecoration(
                                  color: GlobalColors.secondaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check_rounded,
                                  color: Colors.white,
                                  size: 100,
                                ),
                              ),
                            ),
                            const Gap(35),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'add_folder_success'.tr,
                                style: GoogleFonts.outfit(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: GlobalColors.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          navigator!.pop();
                        },
                      ),
                    ),
                  ],
                );
              } else if (state is FolderToTopicLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Form(
                  key: _addFolderFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => navigator!.pop(),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color:
                              ColorUtils.getSecondaryBackgroundColor(context),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(
                              10,
                            ),
                          ),
                        ),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Gap(16),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'add_folder'.tr,
                                style: GoogleFonts.outfit(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      ColorUtils.getPrimaryTextColor(context),
                                ),
                              ),
                            ),
                            const Gap(16),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: CustomTextFormField(
                                textEditingController: _folderTitleController,
                                labelText: 'folder_name'.tr,
                              ),
                            ),
                            const Gap(16),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: CustomTextFormField(
                                textEditingController:
                                    _folderDescriptionController,
                                labelText: 'folder_description'.tr,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 20,
                              ),
                              child: ThreeDimensionalButton(
                                onPressed: () {
                                  if (_addFolderFormKey.currentState!
                                      .validate()) {
                                    context.read<FolderToTopicBloc>().add(
                                          CreateFolder(
                                            title: _folderTitleController.text,
                                            description:
                                                _folderDescriptionController
                                                    .text,
                                          ),
                                        );
                                  }
                                },
                                buttonText: 'save'.tr,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            navigator!.pop();
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}
