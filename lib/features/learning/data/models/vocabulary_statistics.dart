import 'package:final_flashcard/features/learning/domain/entities/vocabulary_statistics.dart';
import 'package:final_flashcard/features/topic/data/model/vocabulary.dart';

class VocabularyStatisticsModel extends VocabularyStatistics {
  const VocabularyStatisticsModel({
    int? id,
    VocabularyModel? vocabulary,
    int? correctCount,
    int? incorrectCount,
    int? totalAnswered,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) : super(
          id: id,
          vocabulary: vocabulary,
          correctCount: correctCount,
          incorrectCount: incorrectCount,
          totalAnswered: totalAnswered,
          createdAt: createdAt,
          updatedAt: updatedAt,
          deletedAt: deletedAt,
        );

  factory VocabularyStatisticsModel.fromJson(Map<String, dynamic> json) {
    return VocabularyStatisticsModel(
      id: json['id'],
      vocabulary: json['vocabulary'] != null
          ? VocabularyModel.fromJson(json['vocabulary'])
          : null,
      correctCount: json['correctCount'],
      incorrectCount: json['incorrectCount'],
      totalAnswered: json['totalAnswered'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      deletedAt:
          json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }

  factory VocabularyStatisticsModel.fromEntity(VocabularyStatistics entity) {
    return VocabularyStatisticsModel(
      id: entity.id,
      vocabulary: entity.vocabulary != null
          ? VocabularyModel.fromEntity(entity.vocabulary!)
          : null,
      correctCount: entity.correctCount,
      incorrectCount: entity.incorrectCount,
      totalAnswered: entity.totalAnswered,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      deletedAt: entity.deletedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vocabulary': vocabulary != null
          ? VocabularyModel.fromEntity(vocabulary!).toJson()
          : null,
      'correctCount': correctCount,
      'incorrectCount': incorrectCount,
      'totalAnswered': totalAnswered,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }
}
