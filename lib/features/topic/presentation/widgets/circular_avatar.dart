import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CircularAvatar extends StatelessWidget {
  const CircularAvatar({
    super.key,
    required this.url,
    this.size = 40,
    this.topRightBadge,
    this.completePercentage,
  });
  final String url;
  final double size;
  final int? topRightBadge;
  final double? completePercentage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: url,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                width: size,
                fit: BoxFit.cover,
                height: size,
              ),
            ),
          ),
          if (completePercentage != null)
            Positioned.fill(
              child: Center(
                child: SizedBox(
                  width: size,
                  height: size,
                  child: RotatedBox(
                    quarterTurns: 2,
                    child: CircularProgressIndicator(
                      value: completePercentage,
                      backgroundColor: Colors.transparent,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        GlobalColors.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (topRightBadge != null)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: topRightBadge == 1
                      ? GlobalColors.secondaryColor
                      : topRightBadge == 2
                          ? GlobalColors.blueColor
                          : GlobalColors.orangeColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    topRightBadge.toString(),
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
