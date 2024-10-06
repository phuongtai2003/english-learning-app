import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:final_flashcard/configs/common/widgets/custom_text_form_field.dart';
import 'package:final_flashcard/configs/common/widgets/oauth_button.dart';
import 'package:final_flashcard/configs/common/widgets/three_dimensional_button.dart';
import 'package:final_flashcard/configs/routes/route_generator.dart';
import 'package:final_flashcard/core/utils/ui_helpers.dart';
import 'package:final_flashcard/features/authentication/presentation/bloc/register/register_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final dateOfBirthController = TextEditingController();

  @override
  dispose() {
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    dateOfBirthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterLoading) {
          UIHelpers.showLoadingDialog(context);
        }
        if (state is RegisterSuccess) {
          Navigator.of(context).pop();
          UIHelpers.showAwesomeDialog(
            context: context,
            title: 'success'.tr,
            message: 'register_success'.tr,
            type: DialogType.success,
          );
        }
        if (state is RegisterError) {
          Navigator.of(context).pop();
          UIHelpers.showAwesomeDialog(
            context: context,
            title: 'error'.tr,
            message: state.data.error.tr,
            type: DialogType.error,
          );
        }
      },
      builder: (context, state) => SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(20),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
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
                const Gap(20),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'sign_up'.tr.toUpperCase(),
                        style: GoogleFonts.outfit(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: ColorUtils.getPrimaryTextColor(context),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          navigator!.pushNamed(
                            RouteGenerator.login,
                          );
                        },
                        child: Text(
                          'sign_in'.tr.toUpperCase(),
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
                const Gap(5),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Text(
                    'create_new_account'.tr,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: ColorUtils.getPrimaryTextColor(context),
                    ),
                  ),
                ),
                const Gap(20),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: CustomTextFormField(
                    textEditingController: emailController,
                    labelText: 'Email',
                  ),
                ),
                const Gap(20),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: CustomTextFormField(
                    textEditingController: nameController,
                    labelText: 'name'.tr,
                  ),
                ),
                const Gap(20),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: CustomTextFormField(
                    textEditingController: dateOfBirthController,
                    labelText: 'date_of_birth'.tr,
                    readOnly: true,
                    icon: FontAwesomeIcons.calendar,
                    onReadOnlyTap: () async {
                      final currentDate = dateOfBirthController.text.isEmpty
                          ? DateTime.now()
                          : UIHelpers.dateParsing(
                              dateOfBirthController.text,
                            );
                      final date = await UIHelpers.showBirthDatePicker(
                          context, currentDate);
                      dateOfBirthController.text =
                          UIHelpers.dateFormatting(date);
                    },
                  ),
                ),
                const Gap(20),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: CustomTextFormField(
                    textEditingController: passwordController,
                    labelText: 'password'.tr,
                    isPassword:
                        state.data.isShowPassword == true ? false : true,
                    icon: state.data.isShowPassword == true
                        ? FontAwesomeIcons.eye
                        : FontAwesomeIcons.eyeSlash,
                    onIconTap: () {
                      context.read<RegisterBloc>().add(
                            const ShowPasswordEvent(),
                          );
                    },
                  ),
                ),
                const Gap(20),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: CustomTextFormField(
                    textEditingController: confirmPasswordController,
                    labelText: 'confirm_password'.tr,
                    isPassword: state.data.isShowConfirmPassword == true
                        ? false
                        : true,
                    icon: state.data.isShowConfirmPassword == true
                        ? FontAwesomeIcons.eye
                        : FontAwesomeIcons.eyeSlash,
                    onIconTap: () {
                      context.read<RegisterBloc>().add(
                            const ShowConfirmPasswordEvent(),
                          );
                    },
                  ),
                ),
                const Gap(20),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: ThreeDimensionalButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        if (passwordController.text !=
                            confirmPasswordController.text) {
                          UIHelpers.showAwesomeDialog(
                            context: context,
                            title: 'error'.tr,
                            message: 'password_not_match'.tr,
                            type: DialogType.error,
                          );
                          return;
                        }
                        context.read<RegisterBloc>().add(
                              RegisterAccountEvent(
                                email: emailController.text,
                                password: passwordController.text,
                                name: nameController.text,
                                dateOfBirth: UIHelpers.dateParsing(
                                  dateOfBirthController.text,
                                ),
                              ),
                            );
                      }
                    },
                    buttonText: 'register'.tr,
                  ),
                ),
                const Gap(20),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 2,
                          color: ColorUtils.getAlternateColor(context),
                        ),
                      ),
                      const Gap(10),
                      Text(
                        'or'.tr.toUpperCase(),
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: ColorUtils.getSecondaryTextColor(context),
                        ),
                      ),
                      const Gap(10),
                      Expanded(
                        child: Divider(
                          thickness: 2,
                          color: ColorUtils.getAlternateColor(context),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(20),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OAuthButton(
                        oauthUrl: 'assets/images/google_icon.svg',
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                const Gap(20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
