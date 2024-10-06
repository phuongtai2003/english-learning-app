import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SecondOnBoardingPage extends StatelessWidget {
  const SecondOnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          ClipPath(
            clipper: SecondOnBoardingClipper(),
            child: Image.asset(
              'assets/images/onboard-02.png',
              fit: BoxFit.fill,
            ),
          ),
          const Gap(10),
          Text(
            'multilangual_support'.tr,
            style: GoogleFonts.outfit(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: GlobalColors.primaryColor,
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'multi_language_support'.tr,
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SecondOnBoardingClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.9);

    final firstControlPoint = Offset(size.width * 0.2, size.height * 0.9);
    final firstEndPoint = Offset(size.width * 0.4, size.height * 0.95);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    final secondControlPoint = Offset(size.width * 0.6, size.height);
    final secondEndPoint = Offset(size.width * 0.8, size.height * 0.9);

    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    final thirdControlPoint = Offset(size.width * 0.95, size.height * 0.85);
    final thirdEndPoint = Offset(size.width, size.height * 0.9);

    path.quadraticBezierTo(thirdControlPoint.dx, thirdControlPoint.dy,
        thirdEndPoint.dx, thirdEndPoint.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
