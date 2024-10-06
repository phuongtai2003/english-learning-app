import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:final_flashcard/configs/common/global_constants.dart';
import 'package:final_flashcard/configs/routes/route_generator.dart';
import 'package:final_flashcard/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with AfterLayoutMixin {
  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    context.read<SplashBloc>().add(const SplashCheckEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) async {
        if (state is! SplashStateLoading && state is! SplashStateInitial) {
          final config = state.data.configuration;
          Get.updateLocale(
            Locale(config?.languageCode ?? 'en'),
          );
          Get.changeThemeMode(
            config?.isDarkMode == null
                ? ThemeMode.system
                : config?.isDarkMode == true
                    ? ThemeMode.dark
                    : ThemeMode.light,
          );
        }
        if (state is SplashStateError) {
          await Future.delayed(const Duration(seconds: 2), () {
            navigator!.pushNamedAndRemoveUntil(
              RouteGenerator.authentication,
              (route) => false,
            );
          });
        }
        if (state is SplashStateToMain) {
          await Future.delayed(const Duration(seconds: 2), () {
            navigator!.pushNamedAndRemoveUntil(
              RouteGenerator.commonBottomNavbar,
              (route) => false,
            );
          });
        } else if (state is SplashStateNotFirstTime) {
          await Future.delayed(const Duration(seconds: 2), () {
            navigator!.pushNamedAndRemoveUntil(
              RouteGenerator.authentication,
              (route) => false,
            );
          });
        } else if (state is SplashStateFirstTime) {
          await Future.delayed(const Duration(seconds: 2), () {
            navigator!.pushNamedAndRemoveUntil(
              RouteGenerator.onBoarding,
              (route) => false,
            );
          });
        }
      },
      child: Center(
        child: Hero(
          tag: GlobalConstants.appIconTag,
          child: Image.asset(
            'assets/images/app_icon.png',
            width: 100,
            height: 100,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
