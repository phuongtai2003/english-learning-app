import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:flutter/material.dart';

class AddMoreWidget extends StatelessWidget {
  const AddMoreWidget({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: ColorUtils.getAlternateColor(context).withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
        color: GlobalColors.primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Material(
            color: GlobalColors.secondaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(100),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 60,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
