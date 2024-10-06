import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:final_flashcard/configs/common/widgets/custom_main_switch.dart';
import 'package:final_flashcard/configs/common/widgets/custom_text_form_field.dart';
import 'package:final_flashcard/configs/common/widgets/primary_button.dart';
import 'package:final_flashcard/configs/common/widgets/three_dimensional_button.dart';
import 'package:final_flashcard/configs/routes/route_generator.dart';
import 'package:final_flashcard/core/utils/ui_helpers.dart';
import 'package:final_flashcard/di/di_config.dart';
import 'package:final_flashcard/features/authentication/presentation/widgets/otp_input.dart';
import 'package:final_flashcard/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _imagePicker = getIt.get();
  final _nameChangeFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _newEmailController = TextEditingController();
  final _otpControllersList =
      List.generate(4, (index) => TextEditingController());
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();
  final _changePasswordFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _newEmailController.dispose();
    for (var controller in _otpControllersList) {
      controller.dispose();
    }
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoading) {
          UIHelpers.showLoadingDialog(context);
        } else if (state is ProfileLoaded) {
          navigator!.pop();
        } else if (state is ProfileLogout) {
          navigator!
              .pushNamedAndRemoveUntil(RouteGenerator.login, (route) => false);
        } else if (state is ProfilePickImage) {
          navigator!.pop();
        } else if (state is ProfileError) {
          navigator!.pop();
          context.read<ProfileBloc>().add(const ProfileLogoutEvent());
        } else if (state is ProfileVerifyPasswordSuccess) {
          navigator!.pop();
          _showChangeEmailSheet(context);
        } else if (state is ProfileSendOtpNewEmailSuccess) {
          navigator!.pop();
          _showEnterOtpNewEmailSheet(context);
        }
      },
      builder: (context, state) {
        _nameController.text = state.data.profile?.name ?? '';
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ).copyWith(top: 16),
                  child: Text(
                    'profile'.tr,
                    style: GoogleFonts.outfit(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: ColorUtils.getPrimaryTextColor(context),
                    ),
                  ),
                ),
                const Gap(16),
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final image = await _imagePicker.pickImage(
                            source: ImageSource.gallery,
                          );
                          if (image != null && context.mounted) {
                            context.read<ProfileBloc>().add(
                                  ProfilePickImageEvent(
                                    File(image.path),
                                  ),
                                );
                          }
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 2,
                              color: ColorUtils.getAlternateColor(context),
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage: CachedNetworkImageProvider(
                              state.data.profile?.image ?? '',
                            ),
                          ),
                        ),
                      ),
                      const Gap(8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              state.data.profile?.name ?? '',
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: ColorUtils.getPrimaryTextColor(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Gap(16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'personal_information'.tr,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: ColorUtils.getPrimaryTextColor(context),
                    ),
                  ),
                ),
                const Gap(6),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: ColorUtils.getAlternateColor(context),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'name'.tr,
                                    style: GoogleFonts.outfit(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: ColorUtils.getPrimaryTextColor(
                                          context),
                                    ),
                                  ),
                                  Text(
                                    state.data.profile?.name ?? '',
                                    style: GoogleFonts.outfit(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _showChangeNameDialog(context);
                              },
                              icon: const Icon(
                                Icons.keyboard_arrow_right_rounded,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 10,
                        thickness: 1,
                        color: ColorUtils.getAlternateColor(context),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Email'.tr,
                                    style: GoogleFonts.outfit(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: ColorUtils.getPrimaryTextColor(
                                          context),
                                    ),
                                  ),
                                  Text(
                                    state.data.profile?.email ?? '',
                                    style: GoogleFonts.outfit(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _showChangeEmailEnterPasswordSheet(context);
                              },
                              icon: const Icon(
                                  Icons.keyboard_arrow_right_rounded),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 10,
                        thickness: 1,
                        color: ColorUtils.getAlternateColor(context),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: GestureDetector(
                          onTap: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  'change_password'.tr,
                                  style: GoogleFonts.outfit(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color:
                                        ColorUtils.getPrimaryTextColor(context),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  _changePasswordBottomSheet(context);
                                },
                                icon: const Icon(
                                  Icons.keyboard_arrow_right_rounded,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'offline_studying'.tr,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: ColorUtils.getPrimaryTextColor(context),
                    ),
                  ),
                ),
                const Gap(6),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: ColorUtils.getAlternateColor(context),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'save_sets_offline'.tr,
                                style: GoogleFonts.outfit(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color:
                                      ColorUtils.getPrimaryTextColor(context),
                                ),
                              ),
                              Text(
                                'save_for_offline'.tr,
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        CustomMainSwitch(
                          value: state.data.profile?.saveSets ?? false,
                          onChanged: (value) {
                            context.read<ProfileBloc>().add(
                                  ProfileChangeSaveSetsEvent(
                                    value,
                                  ),
                                );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'notifications'.tr,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: ColorUtils.getPrimaryTextColor(context),
                    ),
                  ),
                ),
                const Gap(6),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: ColorUtils.getAlternateColor(context),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'push_notifications'.tr,
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: ColorUtils.getPrimaryTextColor(context),
                          ),
                        ),
                        CustomMainSwitch(
                          value: state.data.profile?.pushNotification ?? false,
                          onChanged: (value) {
                            context.read<ProfileBloc>().add(
                                  ProfileChangePushNotificationEvent(
                                    value,
                                  ),
                                );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'appearance'.tr,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: ColorUtils.getPrimaryTextColor(context),
                    ),
                  ),
                ),
                const Gap(6),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: ColorUtils.getAlternateColor(context),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'dark_mode'.tr,
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: ColorUtils.getPrimaryTextColor(context),
                              ),
                            ),
                            CustomMainSwitch(
                              value: state.data.profile?.darkMode ??
                                  Theme.of(context).brightness ==
                                      Brightness.dark,
                              onChanged: (value) {
                                context.read<ProfileBloc>().add(
                                      ProfileChangeDarkModeEvent(
                                        value,
                                      ),
                                    );
                                Get.changeThemeMode(
                                  Get.isDarkMode
                                      ? ThemeMode.light
                                      : ThemeMode.dark,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 10,
                        thickness: 1,
                        color: ColorUtils.getAlternateColor(context),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              state.data.profile?.language == 'vi'
                                  ? 'vietnamese'.tr
                                  : 'english'.tr,
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: ColorUtils.getPrimaryTextColor(context),
                              ),
                            ),
                            CustomMainSwitch(
                              value: state.data.profile?.language == 'vi'
                                  ? true
                                  : false,
                              onChanged: (value) {
                                context.read<ProfileBloc>().add(
                                      ProfileChangeLanguageEvent(
                                        value ? 'vi' : 'en',
                                      ),
                                    );
                                Get.updateLocale(
                                  value
                                      ? const Locale('vi')
                                      : const Locale('en'),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: PrimaryButton(
                    onPressed: () {
                      context.read<ProfileBloc>().add(
                            const ProfileLogoutEvent(),
                          );
                    },
                    buttonText: 'logout'.tr,
                  ),
                ),
                const Gap(32),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showChangeNameDialog(BuildContext cntext) async {
    await showDialog(
      context: cntext,
      useSafeArea: true,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          content: BlocBuilder<ProfileBloc, ProfileState>(
            bloc: cntext.read<ProfileBloc>(),
            builder: (context, state) {
              if (state is ProfileChangeNameLoading) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: ColorUtils.getSecondaryBackgroundColor(cntext),
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                    ],
                  ),
                );
              } else if (state is ProfileChangeNameError) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 24,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        padding: const EdgeInsets.all(16),
                        child: const Icon(
                          FontAwesomeIcons.xmark,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const Gap(16),
                      Text(
                        state.data.error.tr,
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: ColorUtils.getPrimaryTextColor(cntext),
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state is ProfileChangeNameSuccess) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 24,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: GlobalColors.primaryColor,
                        ),
                        padding: const EdgeInsets.all(16),
                        child: const Icon(
                          FontAwesomeIcons.check,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const Gap(16),
                      Text(
                        'change_name_success'.tr,
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: ColorUtils.getPrimaryTextColor(cntext),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Form(
                key: _nameChangeFormKey,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: ColorUtils.getSecondaryBackgroundColor(cntext),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextFormField(
                        textEditingController: _nameController,
                        labelText: 'name'.tr,
                      ),
                      const Gap(10),
                      ThreeDimensionalButton(
                        onPressed: () {
                          cntext.read<ProfileBloc>().add(
                                ProfileChangeNameEvent(
                                  _nameController.text,
                                ),
                              );
                        },
                        buttonText: 'save'.tr,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    ).whenComplete(
      () => cntext.read<ProfileBloc>().add(const ProfileGetProfileEvent()),
    );
  }

  void _showChangeEmailEnterPasswordSheet(BuildContext cntext) async {
    await showModalBottomSheet(
      context: cntext,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      useSafeArea: true,
      backgroundColor: ColorUtils.getPrimaryBackgroundColor(cntext),
      builder: (_) {
        final size = MediaQuery.of(cntext).size;
        return BlocBuilder<ProfileBloc, ProfileState>(
          bloc: cntext.read<ProfileBloc>(),
          builder: (context, state) {
            if (state is ProfileVerifyPasswordLoading) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  color: ColorUtils.getSecondaryBackgroundColor(cntext),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(),
                    ),
                  ],
                ),
              );
            } else if (state is ProfileVerifyPasswordError) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  color: ColorUtils.getSecondaryBackgroundColor(cntext),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      margin: const EdgeInsets.all(16),
                      child: const Icon(
                        FontAwesomeIcons.xmark,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    Text(
                      state.data.error.tr,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: ColorUtils.getPrimaryTextColor(cntext),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is ProfileVerifyPasswordSuccess) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  color: ColorUtils.getSecondaryBackgroundColor(cntext),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: GlobalColors.primaryColor,
                      ),
                      margin: const EdgeInsets.all(16),
                      child: const Icon(
                        FontAwesomeIcons.check,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    Text(
                      'change_email_success'.tr,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: ColorUtils.getPrimaryTextColor(cntext),
                      ),
                    ),
                  ],
                ),
              );
            }
            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                color: ColorUtils.getSecondaryBackgroundColor(cntext),
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Wrap(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 24),
                          height: 8,
                          width: size.width * 0.25,
                          decoration: BoxDecoration(
                            color: ColorUtils.getAlternateColor(cntext),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const Gap(8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'change_email'.tr,
                          style: GoogleFonts.outfit(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: ColorUtils.getPrimaryTextColor(cntext),
                          ),
                        ),
                      ),
                      const Gap(16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'enter_password_first_desc'.tr,
                          style: GoogleFonts.outfit(
                            fontSize: 22,
                            fontWeight: FontWeight.w400,
                            color: ColorUtils.getSecondaryTextColor(cntext),
                          ),
                        ),
                      ),
                      const Gap(16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: CustomTextFormField(
                          textEditingController: _passwordController,
                          isPassword: true,
                          icon: Icons.lock_rounded,
                          onIconTap: () {},
                          labelText: 'password'.tr,
                        ),
                      ),
                      const Gap(16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ThreeDimensionalButton(
                          onPressed: () {
                            cntext.read<ProfileBloc>().add(
                                  ProfileVerifyPasswordEvent(
                                    _passwordController.text,
                                  ),
                                );
                          },
                          buttonText: 'submit'.tr,
                        ),
                      ),
                      const Gap(16),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    ).whenComplete(
      () => cntext.read<ProfileBloc>().add(
            const ProfileGetProfileEvent(),
          ),
    );
  }

  void _showEnterOtpNewEmailSheet(BuildContext cntext) async {
    await showModalBottomSheet(
      context: cntext,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      useSafeArea: true,
      backgroundColor: ColorUtils.getPrimaryBackgroundColor(cntext),
      builder: (_) {
        return BlocBuilder<ProfileBloc, ProfileState>(
          bloc: cntext.read<ProfileBloc>(),
          builder: (context, state) {
            final size = MediaQuery.of(cntext).size;
            if (state is ProfileVerifyNewEmailLoading) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  color: ColorUtils.getSecondaryBackgroundColor(cntext),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(),
                    ),
                  ],
                ),
              );
            } else if (state is ProfileVerifyNewEmailError) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  color: ColorUtils.getSecondaryBackgroundColor(cntext),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      margin: const EdgeInsets.all(16),
                      child: const Icon(
                        FontAwesomeIcons.xmark,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    Text(
                      state.data.error.tr,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: ColorUtils.getPrimaryTextColor(cntext),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is ProfileVerifyNewEmailSuccess) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  color: ColorUtils.getSecondaryBackgroundColor(cntext),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: GlobalColors.primaryColor,
                      ),
                      margin: const EdgeInsets.all(16),
                      child: const Icon(
                        FontAwesomeIcons.check,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    Text(
                      'change_email_success'.tr,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: ColorUtils.getPrimaryTextColor(cntext),
                      ),
                    ),
                  ],
                ),
              );
            }
            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                color: ColorUtils.getSecondaryBackgroundColor(cntext),
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 24),
                      height: 8,
                      width: size.width * 0.25,
                      decoration: BoxDecoration(
                        color: ColorUtils.getAlternateColor(cntext),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'change_email'.tr,
                      style: GoogleFonts.outfit(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: ColorUtils.getPrimaryTextColor(cntext),
                      ),
                    ),
                  ),
                  const Gap(16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'enter_your_otp_desc'.tr,
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        color: ColorUtils.getSecondaryTextColor(cntext),
                      ),
                    ),
                  ),
                  const Gap(16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: OtpInputTextField(
                            controller: _otpControllersList[0],
                            onChanged: (value) {
                              if (value.isEmpty) {
                                FocusScope.of(context).unfocus();
                              }
                              if (value.isNotEmpty) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                          ),
                        ),
                        const Gap(10),
                        Expanded(
                          child: OtpInputTextField(
                            controller: _otpControllersList[1],
                            onChanged: (value) {
                              if (value.isEmpty) {
                                FocusScope.of(context).previousFocus();
                              } else if (value.length == 1) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                          ),
                        ),
                        const Gap(10),
                        Expanded(
                          child: OtpInputTextField(
                            controller: _otpControllersList[2],
                            onChanged: (value) {
                              if (value.isEmpty) {
                                FocusScope.of(context).previousFocus();
                              } else if (value.length == 1) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                          ),
                        ),
                        const Gap(10),
                        Expanded(
                          child: OtpInputTextField(
                            controller: _otpControllersList[3],
                            onChanged: (value) {
                              if (value.isEmpty) {
                                FocusScope.of(context).previousFocus();
                              } else if (value.length == 1) {
                                FocusScope.of(context).unfocus();
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
                    child: ThreeDimensionalButton(
                      onPressed: () {
                        cntext.read<ProfileBloc>().add(
                              ProfileVerifyNewEmailEvent(
                                _newEmailController.text,
                                _otpControllersList.map((e) => e.text).join(""),
                              ),
                            );
                      },
                      buttonText: 'submit'.tr,
                    ),
                  ),
                  const Gap(16),
                ],
              ),
            );
          },
        );
      },
    ).whenComplete(
      () => cntext.read<ProfileBloc>().add(
            const ProfileGetProfileEvent(),
          ),
    );
  }

  void _showChangeEmailSheet(BuildContext cntext) async {
    await showModalBottomSheet(
      context: cntext,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      useSafeArea: true,
      backgroundColor: ColorUtils.getPrimaryBackgroundColor(cntext),
      builder: (_) {
        return BlocBuilder<ProfileBloc, ProfileState>(
          bloc: cntext.read<ProfileBloc>(),
          builder: (context, state) {
            final size = MediaQuery.of(cntext).size;
            if (state is ProfileSendOtpNewEmailLoading) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  color: ColorUtils.getSecondaryBackgroundColor(cntext),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(),
                    ),
                  ],
                ),
              );
            } else if (state is ProfileSendOtpNewEmailError) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  color: ColorUtils.getSecondaryBackgroundColor(cntext),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      margin: const EdgeInsets.all(16),
                      child: const Icon(
                        FontAwesomeIcons.xmark,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    Text(
                      state.data.error.tr,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: ColorUtils.getPrimaryTextColor(cntext),
                      ),
                    ),
                  ],
                ),
              );
            }
            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                color: ColorUtils.getSecondaryBackgroundColor(cntext),
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 24),
                      height: 8,
                      width: size.width * 0.25,
                      decoration: BoxDecoration(
                        color: ColorUtils.getAlternateColor(cntext),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'change_email'.tr,
                      style: GoogleFonts.outfit(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: ColorUtils.getPrimaryTextColor(cntext),
                      ),
                    ),
                  ),
                  const Gap(16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'enter_new_email_desc'.tr,
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        color: ColorUtils.getSecondaryTextColor(cntext),
                      ),
                    ),
                  ),
                  const Gap(16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: CustomTextFormField(
                      textEditingController: _newEmailController,
                      labelText: 'new_email'.tr,
                    ),
                  ),
                  const Gap(16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ThreeDimensionalButton(
                      onPressed: () {
                        cntext.read<ProfileBloc>().add(
                              ProfileSendOtpNewEmailEvent(
                                _newEmailController.text,
                              ),
                            );
                      },
                      buttonText: 'submit'.tr,
                    ),
                  ),
                  const Gap(16),
                ],
              ),
            );
          },
        );
      },
    ).whenComplete(
      () => cntext.read<ProfileBloc>().add(
            const ProfileGetProfileEvent(),
          ),
    );
  }

  void _changePasswordBottomSheet(BuildContext cntext) async {
    await showModalBottomSheet(
      context: cntext,
      useSafeArea: true,
      backgroundColor: ColorUtils.getPrimaryBackgroundColor(cntext),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      isScrollControlled: true,
      builder: (_) {
        final size = MediaQuery.of(cntext).size;
        return BlocBuilder<ProfileBloc, ProfileState>(
          bloc: cntext.read<ProfileBloc>(),
          builder: (context, state) {
            if (state is ProfileChangePasswordLoading) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  color: ColorUtils.getSecondaryBackgroundColor(cntext),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(),
                    ),
                  ],
                ),
              );
            } else if (state is ProfileChangePasswordError) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  color: ColorUtils.getSecondaryBackgroundColor(cntext),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      margin: const EdgeInsets.all(16),
                      child: const Icon(
                        FontAwesomeIcons.xmark,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    Text(
                      state.data.error.tr,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: ColorUtils.getPrimaryTextColor(cntext),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is ProfileChangePasswordSuccess) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  color: ColorUtils.getSecondaryBackgroundColor(cntext),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: GlobalColors.primaryColor,
                      ),
                      margin: const EdgeInsets.all(16),
                      child: const Icon(
                        FontAwesomeIcons.check,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    Text(
                      'change_password_success'.tr,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: ColorUtils.getPrimaryTextColor(cntext),
                      ),
                    ),
                  ],
                ),
              );
            }
            return Form(
              key: _changePasswordFormKey,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  color: ColorUtils.getSecondaryBackgroundColor(cntext),
                ),
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 24),
                          height: 8,
                          width: size.width * 0.25,
                          decoration: BoxDecoration(
                            color: ColorUtils.getAlternateColor(cntext),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'change_password'.tr,
                          style: GoogleFonts.outfit(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: ColorUtils.getPrimaryTextColor(cntext),
                          ),
                        ),
                      ),
                      const Gap(16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'change_password_desc'.tr,
                          style: GoogleFonts.outfit(
                            fontSize: 22,
                            fontWeight: FontWeight.w400,
                            color: ColorUtils.getSecondaryTextColor(cntext),
                          ),
                        ),
                      ),
                      const Gap(16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: CustomTextFormField(
                          isPassword: true,
                          textEditingController: _oldPasswordController,
                          labelText: 'old_password'.tr,
                        ),
                      ),
                      const Gap(16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: CustomTextFormField(
                          isPassword: true,
                          textEditingController: _newPasswordController,
                          labelText: 'new_password'.tr,
                        ),
                      ),
                      const Gap(16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: CustomTextFormField(
                          isPassword: true,
                          textEditingController: _confirmNewPasswordController,
                          labelText: 'new_password_confirm'.tr,
                        ),
                      ),
                      const Gap(16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ThreeDimensionalButton(
                          onPressed: () {
                            if (_changePasswordFormKey.currentState!
                                .validate()) {
                              if (_newPasswordController.text !=
                                  _confirmNewPasswordController.text) {
                                UIHelpers.showAwesomeDialog(
                                  context: context,
                                  title: 'error'.tr,
                                  message: 'password_not_match'.tr,
                                  type: DialogType.warning,
                                );
                              } else {
                                cntext.read<ProfileBloc>().add(
                                      ProfileChangePasswordEvent(
                                        _oldPasswordController.text,
                                        _newPasswordController.text,
                                      ),
                                    );
                              }
                            }
                          },
                          buttonText: 'submit'.tr,
                        ),
                      ),
                      const Gap(16),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(
      () => cntext.read<ProfileBloc>().add(
            const ProfileGetProfileEvent(),
          ),
    );
  }
}
