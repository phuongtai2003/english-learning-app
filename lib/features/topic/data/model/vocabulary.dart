import 'package:final_flashcard/features/topic/domain/entities/vocabulary.dart';

class VocabularyModel extends Vocabulary {
  const VocabularyModel({
    required int? id,
    required String? term,
    required String? definition,
    required String? image,
    required DateTime? createdAt,
    required DateTime? updatedAt,
    required DateTime? deletedAt,
  }) : super(
          id: id,
          term: term,
          definition: definition,
          image: image,
          createdAt: createdAt,
          updatedAt: updatedAt,
          deletedAt: deletedAt,
        );

  factory VocabularyModel.fromJson(Map<String, dynamic> json) {
    return VocabularyModel(
      id: json['id'],
      term: json['term'],
      definition: json['definition'],
      image: json['image'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      deletedAt:
          json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }

  factory VocabularyModel.fromEntity(Vocabulary entity) {
    return VocabularyModel(
      id: entity.id,
      term: entity.term,
      definition: entity.definition,
      image: entity.image,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      deletedAt: entity.deletedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'term': term,
      'definition': definition,
      'image': image,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
}
