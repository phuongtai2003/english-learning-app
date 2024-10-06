import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  colorScheme: const ColorScheme.light(
    background: GlobalColorsLight.primaryBackgroundColor,
    primary: GlobalColors.primaryColor,
    secondary: GlobalColorsLight.secondaryBackgroundColor,
    surfaceTint: GlobalColorsLight.alternateColor,
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  colorScheme: const ColorScheme.dark(
    background: GlobalColorsDark.primaryBackgroundColor,
    primary: GlobalColors.primaryColor,
    secondary: GlobalColorsDark.secondaryBackgroundColor,
    surfaceTint: GlobalColorsDark.alternateColor,
  ),
);
