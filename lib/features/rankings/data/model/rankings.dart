import 'package:final_flashcard/features/learning/data/models/topic_learning_statistics.dart';
import 'package:final_flashcard/features/learning/data/models/vocabulary_statistics.dart';
import 'package:final_flashcard/features/rankings/domain/entities/rankings.dart';

class RankingsModel extends Rankings {
  const RankingsModel({
    int? rank,
    TopicLearningStatisticsModel? topicLearningStatistics,
    List<VocabularyStatisticsModel>? vocabularyStatistics,
  }) : super(
          rank: rank,
          topicLearningStatistics: topicLearningStatistics,
          vocabularyStatistics: vocabularyStatistics,
        );

  factory RankingsModel.fromJson(Map<String, dynamic> json) {
    return RankingsModel(
      rank: json['rank'],
      topicLearningStatistics: json['topicLearningStatistics'] != null
          ? TopicLearningStatisticsModel.fromJson(
              json['topicLearningStatistics'])
          : null,
      vocabularyStatistics: json['vocabularyStatistics'] != null
          ? (json['vocabularyStatistics'] as List)
              .map((e) => VocabularyStatisticsModel.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rank': rank,
      'topicLearningStatistics': topicLearningStatistics != null
          ? TopicLearningStatisticsModel.fromEntity(topicLearningStatistics!)
              .toJson()
          : null,
      'vocabularyStatistics': vocabularyStatistics
          ?.map((e) => VocabularyStatisticsModel.fromEntity(e).toJson())
          .toList(),
    };
  }
}
