import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:flutter/material.dart';

class CustomMainSwitch extends StatelessWidget {
  const CustomMainSwitch({
    super.key,
    required this.onChanged,
    required this.value,
  });

  final Function(bool) onChanged;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return Switch(
      trackOutlineWidth: MaterialStateProperty.all(1),
      trackOutlineColor: MaterialStateProperty.all(
        ColorUtils.getAlternateColor(context),
      ),
      inactiveTrackColor: ColorUtils.getSecondaryTextColor(context),
      inactiveThumbColor: ColorUtils.getAlternateColor(context),
      activeTrackColor: GlobalColors.primaryColor,
      activeColor: GlobalColors.secondaryColor,
      value: value,
      onChanged: onChanged,
    );
  }
}
