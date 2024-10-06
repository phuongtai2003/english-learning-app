
import 'package:final_flashcard/features/topic/domain/entities/flashcard_vocabulary.dart';

class FlashCardVocabularyModel extends FlashCardVocabulary {
  const FlashCardVocabularyModel({
    required super.id,
    required super.term,
    required super.definition,
    required super.image,
    required super.createdAt,
    required super.updatedAt,
    required super.deletedAt,
  });

  factory FlashCardVocabularyModel.fromJson(Map<String, dynamic> json) {
    return FlashCardVocabularyModel(
      id: json['id'],
      term: json['term'],
      definition: json['definition'],
      image: json['image'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
    );
  }

  @override
  List<Object?> get props => [id];
}
