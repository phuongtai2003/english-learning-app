import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:final_flashcard/features/folder/domain/entities/folder.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class LibraryFolderItem extends StatelessWidget {
  const LibraryFolderItem({
    super.key,
    required this.onTap,
    required this.folder,
    this.isSelected = false,
  });
  final VoidCallback onTap;
  final Folder folder;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: GlobalColors.primaryColor.withOpacity(0.2),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 6,
          ),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? GlobalColors.goldColor : Colors.transparent,
              width: 1,
            ),
          ),
          child: SizedBox(
            height: 80,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 20,
                        right: 20,
                        child: Image.asset(
                          'assets/images/header_folder_icon.png',
                          width: double.maxFinite,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/images/app_icon.png',
                          height: 50,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 20,
                        right: 20,
                        child: Image.asset(
                          'assets/images/footer_folder_icon.png',
                          width: double.maxFinite,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(16),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        folder.name ?? '',
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Gap(8),
                      Flexible(
                        child: Text(
                          folder.description ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: ColorUtils.getSecondaryTextColor(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
