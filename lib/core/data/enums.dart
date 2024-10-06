import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:flutter/material.dart';

enum SnackBarType {
  success,
  error,
  warning,
  info,
}

// create to color for the above enums
extension SnackBarTypeExtension on SnackBarType {
  Color toColor() {
    switch (this) {
      case SnackBarType.success:
        return Colors.green;
      case SnackBarType.error:
        return Colors.red;
      case SnackBarType.warning:
        return Colors.orange;
      case SnackBarType.info:
        return Colors.blue;
      default:
        return GlobalColors.primaryColor;
    }
  }
}
