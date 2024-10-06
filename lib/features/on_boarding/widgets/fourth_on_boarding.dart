import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FourthOnBoardingPage extends StatelessWidget {
  const FourthOnBoardingPage({Key? key}) : super(key: key);

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
            clipper: FourthOnBoardingClipper(),
            child: Image.asset(
              'assets/images/onboard-04.png',
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'manage_your_time'.tr,
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
              'manage_your_time_desc'.tr,
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

class FourthOnBoardingClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height);

    final firstControlPoint = Offset(size.width * 0.5, size.height * 0.8);
    final firstEndPoint = Offset(size.width, size.height);

    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
