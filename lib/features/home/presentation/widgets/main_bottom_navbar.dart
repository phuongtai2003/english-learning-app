import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:final_flashcard/configs/common/global_constants.dart';
import 'package:final_flashcard/configs/common/widgets/custom_text_form_field.dart';
import 'package:final_flashcard/configs/common/widgets/three_dimensional_button.dart';
import 'package:final_flashcard/configs/routes/route_generator.dart';
import 'package:final_flashcard/core/data/enums.dart';
import 'package:final_flashcard/core/utils/ui_helpers.dart';
import 'package:final_flashcard/di/di_config.dart';
import 'package:final_flashcard/features/folder/presentation/bloc/folder/folder_bloc.dart';
import 'package:final_flashcard/features/home/presentation/bloc/home_bloc.dart';
import 'package:final_flashcard/features/home/presentation/pages/home_page.dart';
import 'package:final_flashcard/features/home/presentation/widgets/main_bottom_navbar_item.dart';
import 'package:final_flashcard/features/library/presentation/pages/library_page.dart';
import 'package:final_flashcard/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:final_flashcard/features/profile/presentation/pages/profile_page.dart';
import 'package:final_flashcard/features/search/presentation/bloc/search_bloc.dart';
import 'package:final_flashcard/features/search/presentation/pages/search_page.dart';
import 'package:final_flashcard/features/topic/presentation/bloc/add_topic_bloc/add_topic_bloc.dart';
import 'package:final_flashcard/features/topic/presentation/bloc/topic/topic_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MainBottomNavbar extends StatefulWidget {
  const MainBottomNavbar({super.key});

  @override
  State<MainBottomNavbar> createState() => _MainBottomNavbarState();
}

class _MainBottomNavbarState extends State<MainBottomNavbar>
    with AfterLayoutMixin {
  final TextEditingController _folderTitleController = TextEditingController();
  final TextEditingController _folderDescriptionController =
      TextEditingController();
  final _addFolderFormKey = GlobalKey<FormState>();
  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    context.read<ProfileBloc>().add(const ProfileGetProfileEvent());
    context.read<TopicBloc>().add(const GetTopics());
    context.read<FolderBloc>().add(const LoadFolder());
    context.read<SearchBloc>().add(const FetchSearchesTopics());
  }

  void showAddFolderDialog() async {
    await showDialog(
      context: context,
      builder: (_) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: BlocBuilder<FolderBloc, FolderState>(
            bloc: context.read<FolderBloc>(),
            builder: (__, state) {
              if (state is FolderAddFolderSuccess) {
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
              } else if (state is FolderLoading) {
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
                                    context.read<FolderBloc>().add(
                                          AddFolder(
                                            _folderTitleController.text,
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
              }
            },
          ),
        );
      },
    ).whenComplete(() {
      _folderTitleController.clear();
      _folderDescriptionController.clear();
      navigator!.pop();
      context.read<FolderBloc>().add(const LoadFolder());
    });
  }

  void onAddTopicPressed() async {
    final AddTopicBloc? returnedBloc = await navigator!.pushNamed<AddTopicBloc>(
      RouteGenerator.addTopic,
      arguments: {
        'ADD_TOPIC_BLOC': AddTopicBloc(
          getIt.get(),
          getIt.get(),
          getIt.get(),
          getIt.get(),
        ),
      },
    ).whenComplete(
      () {
        navigator!.pop();
        context.read<TopicBloc>().add(const GetTopics());
      },
    );
    if (returnedBloc != null) {
      addPendingBloc(returnedBloc);
    }
  }

  void addPendingBloc(AddTopicBloc addTopicBloc) {
    context.read<TopicBloc>().add(AddPendingBloc(addTopicBloc));
  }

  void onShowActionButton() async {
    await UIHelpers.showFloatingActionButtonPressed(
      context: context,
      onAddTopicPressed: onAddTopicPressed,
      onAddFolderPressed: showAddFolderDialog,
    );
  }

  final List<Widget> pagesList = [
    const HomePage(),
    const SearchPage(),
    const LibraryPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (_, state) {
        if (state is ConnectivityLost) {
          UIHelpers.showSnackBar(
            context,
            'connectivity_lost'.tr,
            SnackBarType.error,
            duration: const Duration(days: 1),
          );
        } else if (state is ConnectivityRestored) {
          UIHelpers.disposeSnackBar(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
          body: pagesList[state.data.currentNavIndex],
          bottomNavigationBar: BottomAppBar(
            surfaceTintColor: Colors.transparent,
            shadowColor: Colors.transparent,
            color: ColorUtils.getSecondaryBackgroundColor(context),
            notchMargin: 10,
            elevation: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: [
                MainBottomNavbarItem(
                  label: 'home'.tr,
                  iconData: FontAwesomeIcons.house,
                  index: 0,
                  onTap: (index) => context
                      .read<HomeBloc>()
                      .add(HomeEvent.changeNavIndex(index)),
                  isSelected: state.data.currentNavIndex == 0,
                ),
                MainBottomNavbarItem(
                  label: 'search'.tr,
                  iconData: FontAwesomeIcons.magnifyingGlass,
                  index: 1,
                  onTap: (index) => context
                      .read<HomeBloc>()
                      .add(HomeEvent.changeNavIndex(index)),
                  isSelected: state.data.currentNavIndex == 1,
                ),
                FloatingActionButton(
                  onPressed: onShowActionButton,
                  heroTag: GlobalConstants.appIconTag,
                  shape: const CircleBorder(),
                  mini: true,
                  child: Image.asset(
                    'assets/images/app_icon.png',
                  ),
                ),
                MainBottomNavbarItem(
                  label: 'library'.tr,
                  iconData: FontAwesomeIcons.folder,
                  index: 2,
                  onTap: (index) => context
                      .read<HomeBloc>()
                      .add(HomeEvent.changeNavIndex(index)),
                  isSelected: state.data.currentNavIndex == 2,
                ),
                MainBottomNavbarItem(
                  label: 'profile'.tr,
                  iconData: FontAwesomeIcons.circleUser,
                  index: 3,
                  onTap: (index) => context
                      .read<HomeBloc>()
                      .add(HomeEvent.changeNavIndex(index)),
                  isSelected: state.data.currentNavIndex == 3,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
