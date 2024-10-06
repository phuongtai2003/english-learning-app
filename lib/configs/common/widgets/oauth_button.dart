import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OAuthButton extends StatelessWidget {
  const OAuthButton(
      {super.key, required this.oauthUrl, required this.onPressed});

  final String oauthUrl;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorUtils.getAlternateColor(context),
      borderRadius: BorderRadius.circular(50),
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: onPressed,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
          ),
          child: SvgPicture.asset(
            oauthUrl,
            width: 30,
            height: 30,
          ),
        ),
      ),
    );
  }
}
