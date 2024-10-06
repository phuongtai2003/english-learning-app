import 'package:final_flashcard/features/learning/domain/entities/matching_card.dart';

class MatchingCardModel extends MatchingCard {
  const MatchingCardModel({
    int? vocabId,
    String? text,
    String? image,
    bool? isTerm,
    bool? isSelected,
    bool? isAnsweredCorrectly,
  }) : super(
          vocabId: vocabId,
          text: text,
          image: image,
          isTerm: isTerm,
          isSelected: isSelected,
          isAnsweredCorrectly: isAnsweredCorrectly,
        );

  factory MatchingCardModel.fromJson(Map<String, dynamic> json) {
    return MatchingCardModel(
      vocabId: json['vocabId'],
      text: json['text'],
      image: json['image'],
      isTerm: json['isTerm'],
      isSelected: json['isSelected'],
      isAnsweredCorrectly: json['isAnsweredCorrectly'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vocabId': vocabId,
      'text': text,
      'image': image,
      'isTerm': isTerm,
      'isSelected': isSelected,
      'isAnsweredCorrectly': isAnsweredCorrectly,
    };
  }
}
