import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:flutter/material.dart';

class MainBottomNavbarItem extends StatelessWidget {
  const MainBottomNavbarItem({
    super.key,
    required this.label,
    required this.iconData,
    required this.index,
    required this.onTap,
    required this.isSelected,
  });

  final String label;
  final IconData iconData;
  final int index;
  final Function(int) onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              color: isSelected
                  ? GlobalColors.primaryColor
                  : ColorUtils.getSecondaryTextColor(context),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
