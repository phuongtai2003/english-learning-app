import 'package:avatar_glow/avatar_glow.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:final_flashcard/configs/common/widgets/custom_text_form_field.dart';
import 'package:final_flashcard/configs/common/widgets/oauth_button.dart';
import 'package:final_flashcard/configs/common/widgets/three_dimensional_button.dart';
import 'package:final_flashcard/configs/routes/route_generator.dart';
import 'package:final_flashcard/core/utils/ui_helpers.dart';
import 'package:final_flashcard/features/authentication/presentation/bloc/login/login_bloc.dart';
import 'package:final_flashcard/features/authentication/presentation/widgets/otp_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final resetPasswordFormKey = GlobalKey<FormState>();
  final emailAddressController = TextEditingController();
  final passwordController = TextEditingController();
  final resetPasswordEmailController = TextEditingController();
  final resetPasswordController = TextEditingController();
  final resetPasswordConfirmController = TextEditingController();
  final otpControllersList = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  @override
  void dispose() {
    super.dispose();
    emailAddressController.dispose();
    passwordController.dispose();
    resetPasswordEmailController.dispose();
    for (final element in otpControllersList) {
      element.dispose();
    }
  }

  void _showEnterEmailBottomSheet(BuildContext btsContext) {
    showModalBottomSheet(
      backgroundColor: ColorUtils.getPrimaryBackgroundColor(btsContext),
      context: btsContext,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) {
        return BlocBuilder<LoginBloc, LoginState>(
          bloc: BlocProvider.of<LoginBloc>(btsContext),
          builder: (context, state) {
            final size = MediaQuery.of(context).size;
            return Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Wrap(
                children: [
                  Column(
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
                            color: ColorUtils.getAlternateColor(context),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'forgot_password'.tr,
                          style: GoogleFonts.outfit(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: ColorUtils.getPrimaryTextColor(context),
                          ),
                        ),
                      ),
                      const Gap(20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'enter_email_to_reset_password'.tr,
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: ColorUtils.getSecondaryTextColor(context),
                          ),
                        ),
                      ),
                      const Gap(20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: CustomTextFormField(
                          labelText: 'Email',
                          textEditingController: resetPasswordEmailController,
                          isPassword: false,
                        ),
                      ),
                      const Gap(20),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: ThreeDimensionalButton(
                          onPressed: () {
                            btsContext.read<LoginBloc>().add(
                                  RequestOtpEvent(
                                    email: resetPasswordEmailController.text,
                                  ),
                                );
                          },
                          buttonText: 'continue_txt'.tr,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showEnterOtpCode(BuildContext btsContext) {
    showModalBottomSheet(
      backgroundColor: ColorUtils.getPrimaryBackgroundColor(btsContext),
      context: btsContext,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return BlocBuilder<LoginBloc, LoginState>(
          bloc: BlocProvider.of<LoginBloc>(btsContext),
          builder: (context, state) {
            final size = MediaQuery.of(context).size;
            return Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Wrap(
                children: [
                  Column(
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
                            color: ColorUtils.getAlternateColor(context),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'enter_4_digits_code'.tr,
                          style: GoogleFonts.outfit(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: ColorUtils.getPrimaryTextColor(context),
                          ),
                        ),
                      ),
                      const Gap(20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'enter_4_digits_code_desc'.tr,
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: ColorUtils.getSecondaryTextColor(context),
                          ),
                        ),
                      ),
                      const Gap(20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SizedBox(
                          height: size.height * 0.1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: OtpInputTextField(
                                  controller: otpControllersList[0],
                                  onChanged: (value) {
                                    if (value.isEmpty) {
                                      FocusScope.of(context).unfocus();
                                    } else if (value.length == 1) {
                                      FocusScope.of(context).nextFocus();
                                    }
                                  },
                                ),
                              ),
                              const Gap(10),
                              Expanded(
                                child: OtpInputTextField(
                                  controller: otpControllersList[1],
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
                                  controller: otpControllersList[2],
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
                                  controller: otpControllersList[3],
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
                      ),
                      const Gap(20),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: ThreeDimensionalButton(
                          onPressed: () {
                            final otpCode = otpControllersList
                                .map((e) => e.text)
                                .toList()
                                .join();
                            btsContext.read<LoginBloc>().add(
                                  VerifyOtpEvent(
                                    email: resetPasswordEmailController.text,
                                    otp: otpCode,
                                  ),
                                );
                          },
                          buttonText: 'continue_txt'.tr,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showChangePasswordSheet(BuildContext btsContext) {
    showModalBottomSheet(
      backgroundColor: ColorUtils.getPrimaryBackgroundColor(btsContext),
      context: btsContext,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) {
        return BlocBuilder<LoginBloc, LoginState>(
          bloc: BlocProvider.of<LoginBloc>(btsContext),
          builder: (context, state) {
            final size = MediaQuery.of(context).size;
            return Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Wrap(
                children: [
                  Column(
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
                            color: ColorUtils.getAlternateColor(context),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'reset_password'.tr,
                          style: GoogleFonts.outfit(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: ColorUtils.getPrimaryTextColor(context),
                          ),
                        ),
                      ),
                      const Gap(20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'reset_password_desc'.tr,
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: ColorUtils.getSecondaryTextColor(context),
                          ),
                        ),
                      ),
                      const Gap(20),
                      Form(
                        key: resetPasswordFormKey,
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: CustomTextFormField(
                                labelText: 'password'.tr,
                                textEditingController: resetPasswordController,
                                isPassword: true,
                              ),
                            ),
                            const Gap(15),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: CustomTextFormField(
                                labelText: 'confirm_password'.tr,
                                textEditingController:
                                    resetPasswordConfirmController,
                                isPassword: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(20),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: ThreeDimensionalButton(
                          onPressed: () {
                            if (resetPasswordFormKey.currentState!.validate()) {
                              if (resetPasswordController.text !=
                                  resetPasswordConfirmController.text) {
                                UIHelpers.showAwesomeDialog(
                                  context: context,
                                  title: 'error'.tr,
                                  message: 'password_not_match'.tr,
                                  type: DialogType.error,
                                );
                              } else {
                                btsContext.read<LoginBloc>().add(
                                      ResetPasswordEvent(
                                        email:
                                            resetPasswordEmailController.text,
                                        password: resetPasswordController.text,
                                      ),
                                    );
                              }
                            }
                          },
                          buttonText: 'continue_txt'.tr,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showResetPasswordSuccess(BuildContext btsContext) {
    showModalBottomSheet(
      backgroundColor: ColorUtils.getPrimaryBackgroundColor(btsContext),
      context: btsContext,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        final size = MediaQuery.of(context).size;
        return Container(
          width: double.infinity,
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Wrap(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                        color: ColorUtils.getAlternateColor(context),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const Gap(30),
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
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'reset_password_success'.tr,
                      style: GoogleFonts.outfit(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: GlobalColors.primaryColor,
                      ),
                    ),
                  ),
                  const Gap(10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'reset_password_success_desc'.tr,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: ColorUtils.getSecondaryTextColor(context),
                      ),
                    ),
                  ),
                  const Gap(20),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: ThreeDimensionalButton(
                      onPressed: () {
                        navigator!.popUntil(
                          (route) => route.isFirst,
                        );
                      },
                      buttonText: 'done'.tr.toUpperCase(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess || state is LoginWithGoogleSuccess) {
          navigator!.pop();
          navigator!.pushNamedAndRemoveUntil(
            RouteGenerator.commonBottomNavbar,
            (route) => false,
          );
        } else if (state is LoginLoading) {
          UIHelpers.showLoadingDialog(context);
        } else if (state is LoginFailed || state is LoginWithGoogleFailed) {
          navigator!.pop();
          UIHelpers.showAwesomeDialog(
            context: context,
            title: 'error'.tr,
            message: state.data.error.tr,
            type: DialogType.error,
          );
        } else if (state is RequestOtpSuccess) {
          navigator!.pop();
          UIHelpers.showAwesomeDialog(
            context: context,
            title: 'success'.tr,
            message: 'reset_password_email_sent'.tr,
            type: DialogType.success,
            onOkPressed: () {
              _showEnterOtpCode(context);
            },
          );
        } else if (state is RequestOtpFailed) {
          navigator!.pop();
          UIHelpers.showAwesomeDialog(
            context: context,
            title: 'error'.tr,
            message: state.data.error.tr,
            type: DialogType.error,
          );
        } else if (state is VerifyOtpSuccess) {
          navigator!.pop();
          _showChangePasswordSheet(context);
        } else if (state is VerifyOtpFailed) {
          navigator!.pop();
          UIHelpers.showAwesomeDialog(
            context: context,
            title: 'error'.tr,
            message: state.data.error.tr,
            type: DialogType.error,
          );
        } else if (state is ResetPasswordSuccess) {
          navigator!.pop();
          _showResetPasswordSuccess(context);
        } else if (state is ResetPasswordFailed) {
          navigator!.pop();
          UIHelpers.showAwesomeDialog(
            context: context,
            title: 'error'.tr,
            message: state.data.error.tr,
            type: DialogType.error,
          );
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Gap(20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/app_icon.png',
                        width: 60,
                        height: 60,
                      ),
                      const Spacer(),
                      Text(
                        'Leaf',
                        style: GoogleFonts.outfit(
                          fontSize: 50,
                          fontWeight: FontWeight.w700,
                          color: GlobalColors.primaryColor,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                const Gap(50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'sign_in'.tr.toUpperCase(),
                        style: GoogleFonts.outfit(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: ColorUtils.getPrimaryTextColor(context),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          navigator!.pushNamed(
                            RouteGenerator.register,
                          );
                        },
                        child: Text(
                          'sign_up'.tr.toUpperCase(),
                          style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: GlobalColors.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(
                  30,
                ),
                Align(
                  alignment: const AlignmentDirectional(0.0, 0.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16)
                        .copyWith(bottom: 16),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 16,
                              top: 10,
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              child: CustomTextFormField(
                                labelText: 'Email',
                                textEditingController: emailAddressController,
                                isPassword: false,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: CustomTextFormField(
                              labelText: 'password'.tr,
                              textEditingController: passwordController,
                              isPassword: !(state.data.isPasswordVisible),
                              icon: state.data.isPasswordVisible
                                  ? FontAwesomeIcons.eye
                                  : FontAwesomeIcons.eyeSlash,
                              onIconTap: () {
                                context.read<LoginBloc>().add(
                                      ShowPasswordEvent(
                                        isShow: !state.data.isPasswordVisible,
                                      ),
                                    );
                              },
                            ),
                          ),
                          const Gap(10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _showEnterEmailBottomSheet(context);
                                  },
                                  child: Text(
                                    'forgot_password'.tr,
                                    style: GoogleFonts.outfit(
                                      color: GlobalColors.primaryColor,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Gap(
                            30,
                          ),
                          Align(
                            alignment: const AlignmentDirectional(0.0, 0.0),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: ThreeDimensionalButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    context.read<LoginBloc>().add(
                                          LoginAccountEvent(
                                            email: emailAddressController.text,
                                            password: passwordController.text,
                                          ),
                                        );
                                  }
                                },
                                buttonText: 'sign_in'.tr,
                              ),
                            ),
                          ),
                          const Gap(20),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        thickness: 2,
                                        color: ColorUtils.getAlternateColor(
                                          context,
                                        ),
                                      ),
                                    ),
                                    const Gap(10),
                                    Text(
                                      'or'.tr.toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.outfit(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: ColorUtils.getSecondaryTextColor(
                                            context),
                                      ),
                                    ),
                                    const Gap(10),
                                    Expanded(
                                      child: Divider(
                                        thickness: 2,
                                        color: ColorUtils.getAlternateColor(
                                          context,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Gap(20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  OAuthButton(
                                    oauthUrl: 'assets/images/google_icon.svg',
                                    onPressed: () {
                                      context
                                          .read<LoginBloc>()
                                          .add(const LoginWithGoogleEvent());
                                    },
                                  ),
                                ],
                              ),
                              const Gap(40),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: GoogleFonts.outfit(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color:
                                        ColorUtils.getPrimaryTextColor(context),
                                    height: 1.5,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "${'by_signing_up'.tr}\n",
                                    ),
                                    TextSpan(
                                      text: 'terms_of_service'.tr,
                                      style: const TextStyle(
                                        color: GlobalColors.primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextSpan(
                                      text: " ${'and'.tr} ",
                                    ),
                                    TextSpan(
                                      text: 'privacy_policy'.tr,
                                      style: const TextStyle(
                                        color: GlobalColors.primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
