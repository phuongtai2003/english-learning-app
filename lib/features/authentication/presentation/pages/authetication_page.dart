import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:final_flashcard/configs/common/widgets/three_dimensional_button.dart';
import 'package:final_flashcard/configs/routes/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:avatar_glow/avatar_glow.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _animation = Tween<double>(begin: 1.0, end: 0).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const Spacer(),
                Align(
                  alignment: Alignment.center,
                  child: AvatarGlow(
                    glowCount: 3,
                    curve: Curves.fastOutSlowIn,
                    animate: true,
                    glowShape: BoxShape.circle,
                    duration: const Duration(seconds: 2),
                    repeat: true,
                    glowColor: GlobalColors.secondaryColor,
                    glowRadiusFactor: 0.15,
                    child: Image.asset(
                      'assets/images/app_icon.png',
                      width: size.width * 0.6,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  'Leaf',
                  style: GoogleFonts.outfit(
                    fontSize: 50,
                    fontWeight: FontWeight.w600,
                    color: GlobalColors.primaryColor,
                  ),
                ),
                const Gap(10),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Text(
                    'app_description'.tr,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: ColorUtils.getPrimaryTextColor(context),
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ThreeDimensionalButton(
                    onPressed: () {
                      navigator!.pushNamed(
                        RouteGenerator.register,
                      );
                    },
                    buttonText: 'sign_up'.tr.toUpperCase(),
                  ),
                ),
                const Gap(16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ThreeDimensionalButton(
                    onPressed: () {
                      navigator!.pushNamed(
                        RouteGenerator.login,
                      );
                    },
                    buttonText: 'sign_in'.tr.toUpperCase(),
                    color: Colors.transparent,
                  ),
                ),
                const Gap(16),
              ],
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: size.height * 0.5 * _animation.value,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: size.height * 0.5 * _animation.value,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
