import 'dart:io';

import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:final_flashcard/di/di_config.dart';
import 'package:final_flashcard/features/topic/domain/entities/flashcard_vocabulary.dart';
import 'package:final_flashcard/features/topic/presentation/widgets/transparent_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

import 'package:image_picker/image_picker.dart';

class FlashCardWidget extends StatefulWidget {
  const FlashCardWidget({
    super.key,
    required this.cardTermController,
    required this.cardDefinitionController,
    required this.cardImage,
    required this.onImagePicked,
    required this.onRemoveImage,
    required this.onRemove,
    this.vocabulary,
  });
  final TextEditingController cardTermController;
  final TextEditingController cardDefinitionController;
  final File? cardImage;
  final Function(File image) onImagePicked;
  final Function() onRemoveImage;
  final Function() onRemove;
  final FlashCardVocabulary? vocabulary;

  @override
  State<FlashCardWidget> createState() => _FlashCardWidgetState();
}

class _FlashCardWidgetState extends State<FlashCardWidget>
    with AutomaticKeepAliveClientMixin {
  bool _isTerm = true;
  double _angle = 0;

  final ImagePicker _imagePicker = getIt.get();

  void _flip() {
    setState(() {
      _angle = (_angle + pi) % (2 * pi);
    });
  }

  void _pickImage() async {
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      widget.onImagePicked(File(image.path));
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: _flip,
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: _angle),
        duration: const Duration(milliseconds: 500),
        builder: (context, value, child) {
          if (value >= (pi / 2)) {
            _isTerm = false;
          } else {
            _isTerm = true;
          }
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(value),
            child: _isTerm
                ? Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 25),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: ColorUtils.getAlternateColor(context),
                                blurRadius: 10,
                                spreadRadius: 5,
                              ),
                            ],
                            color:
                                ColorUtils.getPrimaryBackgroundColor(context),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              TransparentTextFormField(
                                hintText: 'term'.tr,
                                textEditingController:
                                    widget.cardTermController,
                                minLines: 1,
                                maxLines: widget.cardImage != null ? 1 : 3,
                              ),
                              if (widget.cardImage != null) _buildImage(),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 40,
                        left: 15,
                        child: Material(
                          shape: const CircleBorder(),
                          color: Colors.red,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: widget.onRemove,
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                              ),
                              padding: const EdgeInsets.all(8),
                              child: const Icon(
                                Icons.close,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Material(
                        color: ColorUtils.getSecondaryBackgroundColor(context),
                        borderRadius: BorderRadius.circular(16),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: _pickImage,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Image.asset(
                              'assets/images/image_icon.png',
                              width: 30,
                              height: 30,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..rotateY(
                        pi,
                      ),
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 25),
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: ColorUtils.getPrimaryTextColor(context)
                                      .withOpacity(0.2),
                                  blurRadius: 10,
                                  spreadRadius: 5,
                                ),
                              ],
                              color:
                                  ColorUtils.getPrimaryBackgroundColor(context),
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
                                TransparentTextFormField(
                                  hintText: 'definition'.tr,
                                  textEditingController:
                                      widget.cardDefinitionController,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: widget.cardImage != null ? 1 : 3,
                                  minLines: 1,
                                ),
                                if (widget.cardImage != null) _buildImage(),
                              ],
                            ),
                          ),
                        ),
                        Material(
                          color:
                              ColorUtils.getSecondaryBackgroundColor(context),
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: _pickImage,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Image.asset(
                                'assets/images/image_icon.png',
                                width: 30,
                                height: 30,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 40,
                          left: 15,
                          child: Material(
                            shape: const CircleBorder(),
                            color: Colors.red,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: widget.onRemove,
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.transparent,
                                ),
                                padding: const EdgeInsets.all(8),
                                child: const Icon(
                                  Icons.close,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildImage() {
    return Expanded(
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          Image.file(
            widget.cardImage!,
            fit: BoxFit.fill,
          ),
          Positioned(
            top: 6,
            left: 6,
            child: Material(
              shape: const CircleBorder(),
              color: Colors.red,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: widget.onRemoveImage,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.close,
                    size: 14,
                    color: Colors.white,
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
