import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:final_flashcard/core/data/enums.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class UIHelpers {
  static final _numberFormatter = NumberFormat("00", "en_US");
  static disposeSnackBar(BuildContext context) =>
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
  static showSnackBar(
    BuildContext context,
    String message,
    SnackBarType type, {
    Duration duration = const Duration(seconds: 3),
  }) {
    disposeSnackBar(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: duration,
        backgroundColor: type.toColor(),
        content: Text(
          message,
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: ColorUtils.getPrimaryTextColor(context),
          ),
        ),
        action: SnackBarAction(
          label: 'close'.tr,
          textColor: ColorUtils.getPrimaryTextColor(context),
          onPressed: () {
            disposeSnackBar(context);
          },
        ),
      ),
    );
  }

  static showLoadingDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        surfaceTintColor: ColorUtils.getPrimaryBackgroundColor(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              color: GlobalColors.primaryColor,
            ),
            Text(
              'loading'.tr,
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: ColorUtils.getPrimaryTextColor(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> showFloatingActionButtonPressed({
    required BuildContext context,
    required VoidCallback onAddTopicPressed,
    required VoidCallback onAddFolderPressed,
  }) async {
    await showModalBottomSheet(
      backgroundColor: ColorUtils.getSecondaryBackgroundColor(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      isDismissible: true,
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              leading: const Icon(
                FontAwesomeIcons.plus,
                size: 18,
              ),
              title: Text(
                'add_topic'.tr,
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: onAddTopicPressed,
            ),
            ListTile(
              leading: const Icon(
                FontAwesomeIcons.folderOpen,
                size: 18,
              ),
              title: Text(
                'add_folder'.tr,
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: onAddFolderPressed,
            ),
          ],
        );
      },
    );
  }

  static showAwesomeDialog({
    required BuildContext context,
    required String title,
    required String message,
    required DialogType type,
    VoidCallback? onOkPressed,
    String? btnCancel,
    VoidCallback? onCancelPressed,
  }) {
    AwesomeDialog(
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      context: context,
      dialogType: type,
      animType: AnimType.rightSlide,
      title: title,
      desc: message,
      btnOkColor: GlobalColors.primaryColor,
      btnCancelText: btnCancel,
      btnOkOnPress: onOkPressed ?? () {},
      btnCancelOnPress: onCancelPressed,
    ).show();
  }

  static Future<DateTime> showBirthDatePicker(
      BuildContext context, DateTime currentDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    return picked ?? DateTime.now();
  }

  static String dateFormatting(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static DateTime dateParsing(String date) {
    return DateFormat('dd/MM/yyyy').parse(date);
  }

  static String formatNumber(int number) {
    return _numberFormatter.format(number);
  }
}
