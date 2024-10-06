import 'package:equatable/equatable.dart';

class MatchingCard extends Equatable {
  final int? vocabId;
  final String? text;
  final String? image;
  final bool? isTerm;
  final bool? isSelected;
  final bool? isAnsweredCorrectly;

  const MatchingCard({
    this.vocabId,
    this.text,
    this.image,
    this.isTerm,
    this.isSelected,
    this.isAnsweredCorrectly,
  });

  @override
  List<Object?> get props => [
        vocabId,
        text,
        image,
        isTerm,
        isSelected,
        isAnsweredCorrectly,
      ];

  MatchingCard copyWith({
    int? vocabId,
    String? text,
    String? image,
    bool? isTerm,
    bool? isSelected,
    bool? isAnsweredCorrectly,
  }) {
    return MatchingCard(
      vocabId: vocabId ?? this.vocabId,
      text: text ?? this.text,
      image: image ?? this.image,
      isTerm: isTerm ?? this.isTerm,
      isSelected: isSelected ?? this.isSelected,
      isAnsweredCorrectly: isAnsweredCorrectly ?? this.isAnsweredCorrectly,
    );
  }
}
