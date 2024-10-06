import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FirstOnBoardingPage extends StatelessWidget {
  const FirstOnBoardingPage({super.key});

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
            clipper: FirstOnBoardingClipper(),
            child: Image.asset(
              'assets/images/onboard-01.png',
              fit: BoxFit.cover,
            ),
          ),
          const Gap(10),
          Text(
            'anywhere_anytime'.tr,
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
              'leaf_helps_you'.tr,
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

class FirstOnBoardingClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height * 0.95);

    final firstControlPoint = Offset(size.width * 0.25, size.height * 0.8);
    final firstEndPoint = Offset(size.width * 0.5, size.height * 0.9);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    final secondControlPoint = Offset(size.width * 0.75, size.height);
    final secondEndPoint = Offset(size.width, size.height * 0.9);

    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
