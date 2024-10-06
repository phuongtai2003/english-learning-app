import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:final_flashcard/configs/common/widgets/primary_button.dart';
import 'package:final_flashcard/configs/routes/route_generator.dart';
import 'package:final_flashcard/features/on_boarding/widgets/first_on_boarding.dart';
import 'package:final_flashcard/features/on_boarding/widgets/fourth_on_boarding.dart';
import 'package:final_flashcard/features/on_boarding/widgets/second_on_boarding.dart';
import 'package:final_flashcard/features/on_boarding/widgets/third_on_boarding.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter/material.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final pageViewController = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  SafeArea _buildBody(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: PageView(
              controller: pageViewController,
              children: const [
                FirstOnBoardingPage(),
                SecondOnBoardingPage(),
                ThirdOnBoardingPage(),
                FourthOnBoardingPage(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 30,
            ),
            child: SmoothPageIndicator(
              controller: pageViewController,
              count: 4,
              axisDirection: Axis.horizontal,
              onDotClicked: (i) async {
                await pageViewController.animateToPage(
                  i,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease,
                );
              },
              effect: ExpandingDotsEffect(
                expansionFactor: 3.0,
                spacing: 8.0,
                radius: 16.0,
                dotWidth: 16.0,
                dotHeight: 8.0,
                dotColor: ColorUtils.getAlternateColor(context),
                activeDotColor: GlobalColors.primaryColor,
                paintStyle: PaintingStyle.fill,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: PrimaryButton(
              onPressed: () {
                navigator!.pushNamedAndRemoveUntil(
                  RouteGenerator.authentication,
                  (route) => false,
                );
              },
              buttonText: 'get_started'.tr,
            ),
          ),
        ],
      ),
    );
  }
}
