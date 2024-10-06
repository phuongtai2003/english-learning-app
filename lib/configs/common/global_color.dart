import 'package:flutter/material.dart';

class GlobalColorsLight {
  static const Color secondaryBackgroundColor = Color(0XFFf1f4f8);
  static const Color primaryBackgroundColor = Color(0XFFFFFFFF);
  static const Color primaryTextColor = Color(0XFF14181B);
  static const Color secondaryTextColor = Color(0XFF57636C);
  static const Color alternateColor = Color(0XFFE0E3E7);
}

class GlobalColorsDark {
  static const Color primaryBackgroundColor = Color(0XFF1D2428);
  static const Color secondaryBackgroundColor = Color(0XFF14181B);
  static const Color primaryTextColor = Color(0XFFFFFFFF);
  static const Color secondaryTextColor = Color(0XFF95A1AC);
  static const Color alternateColor = Color(0XFF262D34);
}

class GlobalColors {
  static const Color primaryColor = Color(0XFF008E7E);
  static const Color blueColor = Color(0XFF0077B6);
  static const Color secondaryColor = Color(0xff005D53);
  static const Color successColor = Color(0XFF00C851);
  static const Color goldColor = Color(0XFFFFD966);
  static const Color orangeColor = Color.fromARGB(255, 255, 102, 0);
}

class ColorUtils {
  static GlobalColorsLight get lightTheme => GlobalColorsLight();
  static GlobalColorsDark get darkTheme => GlobalColorsDark();

  static Color getPrimaryTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? GlobalColorsLight.primaryTextColor
        : GlobalColorsDark.primaryTextColor;
  }

  static Color getSecondaryTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? GlobalColorsLight.secondaryTextColor
        : GlobalColorsDark.secondaryTextColor;
  }

  static Color getAlternateColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? GlobalColorsLight.alternateColor
        : GlobalColorsDark.alternateColor;
  }

  static Color getSecondaryBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? GlobalColorsLight.secondaryBackgroundColor
        : GlobalColorsDark.secondaryBackgroundColor;
  }

  static Color getPrimaryBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? GlobalColorsLight.primaryBackgroundColor
        : GlobalColorsDark.primaryBackgroundColor;
  }
}
