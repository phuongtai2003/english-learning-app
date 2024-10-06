import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VocabularyItem extends StatefulWidget {
  const VocabularyItem({
    super.key,
    required this.term,
    required this.definition,
    this.imageUrl,
    this.hasShadow = true,
    this.audioWidget,
    this.readTerm,
    this.readDefinition,
    this.isTermSpeaking = false,
    this.isDefinitionSpeaking = false,
    this.isAutoRead = false,
  });
  final String term;
  final String definition;
  final String? imageUrl;
  final bool hasShadow;
  final Widget? audioWidget;
  final VoidCallback? readTerm;
  final VoidCallback? readDefinition;
  final bool isTermSpeaking;
  final bool isDefinitionSpeaking;
  final bool isAutoRead;

  @override
  State<VocabularyItem> createState() => _VocabularyItemState();
}

class _VocabularyItemState extends State<VocabularyItem> {
  bool _isTerm = true;
  double _angle = 0;

  void _flip() {
    setState(() {
      _angle = (_angle + pi) % (2 * pi);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flip,
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: _angle),
        duration: const Duration(milliseconds: 500),
        builder: (_, value, child) {
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
                    fit: StackFit.expand,
                    children: [
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              if (widget.hasShadow) ...[
                                BoxShadow(
                                  color: ColorUtils.getAlternateColor(context),
                                  blurRadius: 10,
                                  spreadRadius: 5,
                                ),
                              ],
                            ],
                            border: !widget.hasShadow
                                ? Border.all(
                                    width: 1,
                                    color: GlobalColors.secondaryColor)
                                : null,
                            color:
                                ColorUtils.getPrimaryBackgroundColor(context),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.term,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.outfit(
                                    fontSize: 18,
                                    color: widget.isTermSpeaking
                                        ? GlobalColors.primaryColor
                                        : ColorUtils.getPrimaryTextColor(
                                            context),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (widget.audioWidget != null)
                        Positioned(
                          right: 20,
                          bottom: 20,
                          child: GestureDetector(
                            onTap: () => widget.readTerm?.call(),
                            child: widget.audioWidget!,
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
                      fit: StackFit.expand,
                      children: [
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                if (widget.hasShadow) ...[
                                  BoxShadow(
                                    color:
                                        ColorUtils.getAlternateColor(context),
                                    blurRadius: 10,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ],
                              border: !widget.hasShadow
                                  ? Border.all(
                                      width: 1,
                                      color: GlobalColors.secondaryColor,
                                    )
                                  : null,
                              color:
                                  ColorUtils.getPrimaryBackgroundColor(context),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.definition,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.outfit(
                                      fontSize: 18,
                                      color: widget.isDefinitionSpeaking
                                          ? GlobalColors.primaryColor
                                          : ColorUtils.getPrimaryTextColor(
                                              context),
                                    ),
                                  ),
                                ),
                                if (widget.imageUrl != null)
                                  Expanded(
                                    child: CachedNetworkImage(
                                      imageUrl: widget.imageUrl ?? '',
                                      height: 100,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        if (widget.audioWidget != null)
                          Positioned(
                            right: 20,
                            bottom: 20,
                            child: GestureDetector(
                              onTap: () => widget.readDefinition?.call(),
                              child: widget.audioWidget!,
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
}
