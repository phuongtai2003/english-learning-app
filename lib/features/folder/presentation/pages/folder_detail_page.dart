import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:final_flashcard/configs/common/widgets/custom_text_form_field.dart';
import 'package:final_flashcard/configs/common/widgets/three_dimensional_button.dart';
import 'package:final_flashcard/configs/routes/route_generator.dart';
import 'package:final_flashcard/core/utils/ui_helpers.dart';
import 'package:final_flashcard/features/folder/domain/entities/folder.dart';
import 'package:final_flashcard/features/folder/presentation/bloc/folder_detail_bloc/folder_detail_bloc.dart';
import 'package:final_flashcard/features/topic/domain/entities/topic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FolderDetailPage extends StatefulWidget {
  const FolderDetailPage({super.key, required this.folder});
  final Folder folder;

  @override
  State<FolderDetailPage> createState() => _FolderDetailPageState();
}

class _FolderDetailPageState extends State<FolderDetailPage> {
  final _editFolderFormKey = GlobalKey<FormState>();
  final _folderTitleController = TextEditingController();
  final _folderDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _folderTitleController.text = widget.folder.name ?? '';
    _folderDescriptionController.text = widget.folder.description ?? '';
  }

  @override
  void dispose() {
    super.dispose();
    _folderTitleController.dispose();
    _folderDescriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.primaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: ColorUtils.getSecondaryBackgroundColor(context),
          ),
          onPressed: () {
            navigator!.pop();
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showFolderDetailOptions(context);
            },
            icon: Icon(
              Icons.more_vert,
              color: ColorUtils.getSecondaryBackgroundColor(context),
            ),
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext cntext) {
    final size = MediaQuery.of(cntext).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    return SafeArea(
      child: BlocConsumer<FolderDetailBloc, FolderDetailState>(
        listener: (context, state) {
          if (state is FolderDetailRemovedTopicSuccess) {
            UIHelpers.showAwesomeDialog(
              context: context,
              title: 'success'.tr,
              message: 'remove_topic_success'.tr,
              type: DialogType.success,
            );
          } else if (state is FolderDetailRemovedTopicError) {
            UIHelpers.showAwesomeDialog(
              context: context,
              title: 'error'.tr,
              message: state.data.error.tr,
              type: DialogType.error,
            );
          } else if (state is FolderDetailEditFolderError) {
            navigator!.pop();
            UIHelpers.showAwesomeDialog(
              context: context,
              title: 'error'.tr,
              message: state.data.error.tr,
              type: DialogType.error,
            );
          } else if (state is FolderDetailEditFolderSuccess) {
            navigator!.pop();
            UIHelpers.showAwesomeDialog(
              context: context,
              title: 'success'.tr,
              message: 'edit_folder_success'.tr,
              type: DialogType.success,
            );
          } else if (state is FolderDetailEditFolderLoading) {
            UIHelpers.showLoadingDialog(context);
          } else if (state is FolderDetailRemoveFolderSuccess) {
            navigator!.pop();
            UIHelpers.showAwesomeDialog(
              context: context,
              title: 'success'.tr,
              message: 'remove_folder_success'.tr,
              type: DialogType.success,
              onOkPressed: () {
                navigator!.pop();
              },
            );
          } else if (state is FolderDetailRemoveFolderError) {
            navigator!.pop();
            UIHelpers.showAwesomeDialog(
              context: context,
              title: 'error'.tr,
              message: state.data.error.tr,
              type: DialogType.error,
            );
          } else if (state is FolderDetailRemoveFolderLoading) {
            UIHelpers.showLoadingDialog(context);
          }
        },
        builder: (context, state) {
          if (state is FolderDetailLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: ColorUtils.getSecondaryBackgroundColor(context),
              ),
            );
          }
          if (state is FolderDetailError) {
            return SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      FontAwesomeIcons.xmark,
                      color: ColorUtils.getSecondaryBackgroundColor(context),
                      size: 100,
                    ),
                  ),
                  const Gap(16),
                  Text(
                    state.data.error.tr,
                    style: GoogleFonts.outfit(
                      fontSize: 30,
                      color: ColorUtils.getSecondaryBackgroundColor(
                        context,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            if (state.data.folder != null) {
              final folderDetail = state.data.folder;
              final topicsList = folderDetail?.topics ?? [];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      folderDetail?.name ?? '',
                      style: GoogleFonts.outfit(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: ColorUtils.getPrimaryBackgroundColor(context),
                      ),
                    ),
                  ),
                  const Gap(16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      folderDetail?.description ?? '',
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: ColorUtils.getPrimaryBackgroundColor(context),
                      ),
                    ),
                  ),
                  const Gap(30),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorUtils.getSecondaryBackgroundColor(context),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(
                            30,
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 24,
                      ),
                      child: GridView.builder(
                        scrollDirection: Axis.vertical,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 10,
                          childAspectRatio: (itemWidth / itemHeight),
                        ),
                        itemBuilder: (context, index) {
                          if (index < topicsList.length) {
                            final topic = topicsList[index];
                            return _buildTopicSlot(topic, cntext);
                          } else {
                            return _buildEmptySlot(cntext, folderDetail!);
                          }
                        },
                        itemCount: topicsList.isEmpty
                            ? 2
                            : topicsList.length % 2 == 0
                                ? topicsList.length + 2
                                : topicsList.length + 1,
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const SizedBox.shrink();
            }
          }
        },
      ),
    );
  }

  Widget _buildTopicSlot(Topic topic, BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                topic.title ?? '',
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: ColorUtils.getPrimaryTextColor(context),
                ),
              ),
            ),
          ],
        ),
        const Gap(8),
        Material(
          borderRadius: BorderRadius.circular(20),
          color: ColorUtils.getPrimaryBackgroundColor(context),
          elevation: 20,
          child: GestureDetector(
            onLongPressStart: (details) {
              _showPopupMenu(context, topic, details);
            },
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => navigateToTopicDetails(topic),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.transparent,
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: topic.image != null
                          ? CachedNetworkImage(
                              imageUrl: topic.image!,
                              fit: BoxFit.contain,
                              width: 100,
                              height: 100,
                            )
                          : Image.asset(
                              'assets/images/app_icon.png',
                              fit: BoxFit.contain,
                              width: 100,
                              height: 100,
                            ),
                    ),
                    const Gap(8),
                    Text(
                      '${topic.vocabularies!.length.toString()} ${'vocabularies'.tr}',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: ColorUtils.getPrimaryTextColor(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  void navigateToTopicDetails(Topic topic) async {
    final folderDetailBloc = context.read<FolderDetailBloc>();
    final userId = folderDetailBloc.state.data.folder?.user?.id;
    await navigator?.pushNamed(
      RouteGenerator.topicDetails,
      arguments: {
        'TOPIC_ID': topic.id,
        'TERM_LANGUAGE': topic.termLocale,
        'DEFINITION_LANGUAGE': topic.definitionLocale,
        'USER_ID': userId,
      },
    );
  }

  void _showPopupMenu(
    BuildContext cntext,
    Topic topic,
    LongPressStartDetails details,
  ) async {
    final offset = details.globalPosition;

    await showMenu(
      context: cntext,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy,
        MediaQuery.of(cntext).size.width - offset.dx,
        MediaQuery.of(cntext).size.height - offset.dy,
      ),
      items: [
        PopupMenuItem<String>(
          onTap: () => navigateToTopicDetails(topic),
          child: Text(
            'view'.tr,
            style: GoogleFonts.outfit(
              fontSize: 18,
              color: ColorUtils.getPrimaryTextColor(cntext),
            ),
          ),
        ),
        PopupMenuItem<String>(
          onTap: () {
            UIHelpers.showAwesomeDialog(
              context: cntext,
              title: 'confirmation'.tr,
              message: 'delete_topic_from_folder_msg'.tr,
              type: DialogType.warning,
              btnCancel: 'cancel'.tr,
              onOkPressed: () {
                cntext.read<FolderDetailBloc>().add(
                      RemoveTopicFromFolder(
                        topicId: topic.id!,
                      ),
                    );
              },
              onCancelPressed: () {},
            );
          },
          child: Text(
            'delete'.tr,
            style: GoogleFonts.outfit(
              fontSize: 18,
              color: ColorUtils.getPrimaryTextColor(cntext),
            ),
          ),
        ),
      ],
    );
  }

  void _onEmptySlotPress(Folder folder, BuildContext cntext) async {
    await navigator!.pushNamed(
      RouteGenerator.addTopicToFolder,
      arguments: {
        'FOLDER': folder,
      },
    ).whenComplete(() {
      cntext.read<FolderDetailBloc>().add(
            LoadFolderDetail(
              folderId: folder.id!,
            ),
          );
    });
  }

  Widget _buildEmptySlot(BuildContext context, Folder folder) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Material(
          borderRadius: BorderRadius.circular(20),
          color: ColorUtils.getPrimaryBackgroundColor(context),
          elevation: 20,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => _onEmptySlotPress(folder, context),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 50),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.transparent,
              ),
              child: Center(
                child: Container(
                  decoration: const BoxDecoration(
                    color: GlobalColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(
                    12,
                  ),
                  child: Icon(
                    Icons.add,
                    color: ColorUtils.getSecondaryBackgroundColor(context),
                    size: 50,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showFolderDetailOptions(BuildContext cntext) async {
    await showModalBottomSheet(
      context: cntext,
      backgroundColor: ColorUtils.getSecondaryBackgroundColor(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      useSafeArea: true,
      isScrollControlled: true,
      builder: (_) {
        return BlocBuilder<FolderDetailBloc, FolderDetailState>(
          bloc: cntext.read<FolderDetailBloc>(),
          builder: (context, state) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 10,
                    width: MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                      color: ColorUtils.getPrimaryBackgroundColor(context),
                      shape: BoxShape.rectangle,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(16),
                      ),
                    ),
                  ),
                  const Gap(10),
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    leading: const Icon(
                      FontAwesomeIcons.plus,
                      size: 18,
                    ),
                    title: Text(
                      'add_topic'.tr,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        color: ColorUtils.getPrimaryTextColor(context),
                      ),
                    ),
                    onTap: () async {
                      navigator!.pop();
                      await navigator!.pushNamed(
                        RouteGenerator.addTopicToFolder,
                        arguments: {
                          'FOLDER': state.data.folder,
                        },
                      ).whenComplete(
                        () => cntext.read<FolderDetailBloc>().add(
                              LoadFolderDetail(
                                folderId: state.data.folder!.id!,
                              ),
                            ),
                      );
                    },
                  ),
                  const Gap(10),
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    leading: const Icon(
                      FontAwesomeIcons.pen,
                      size: 18,
                    ),
                    title: Text(
                      'edit'.tr,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        color: ColorUtils.getPrimaryTextColor(context),
                      ),
                    ),
                    onTap: () {
                      navigator!.pop();
                      _showEditFolderDialog(cntext);
                    },
                  ),
                  const Gap(10),
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    leading: const Icon(
                      FontAwesomeIcons.trash,
                      size: 18,
                    ),
                    title: Text(
                      'delete'.tr,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        color: ColorUtils.getPrimaryTextColor(context),
                      ),
                    ),
                    onTap: () {
                      navigator!.pop();
                      UIHelpers.showAwesomeDialog(
                        context: cntext,
                        title: 'confirmation'.tr,
                        message: 'delete_folder_msg'.tr,
                        type: DialogType.warning,
                        btnCancel: 'cancel'.tr,
                        onOkPressed: () {
                          cntext.read<FolderDetailBloc>().add(
                                const RemoveFolder(),
                              );
                        },
                        onCancelPressed: () {},
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showEditFolderDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: BlocBuilder<FolderDetailBloc, FolderDetailState>(
            bloc: context.read<FolderDetailBloc>(),
            builder: (__, state) {
              return Form(
                key: _editFolderFormKey,
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
                        color: ColorUtils.getSecondaryBackgroundColor(context),
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
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'edit'.tr,
                              style: GoogleFonts.outfit(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: ColorUtils.getPrimaryTextColor(context),
                              ),
                            ),
                          ),
                          const Gap(16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: CustomTextFormField(
                              textEditingController: _folderTitleController,
                              labelText: 'folder_name'.tr,
                            ),
                          ),
                          const Gap(16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                                if (_editFolderFormKey.currentState!
                                    .validate()) {
                                  context.read<FolderDetailBloc>().add(
                                        EditFolder(
                                          folderName:
                                              _folderTitleController.text,
                                          folderDescription:
                                              _folderDescriptionController.text,
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
            },
          ),
        );
      },
    );
  }
}
