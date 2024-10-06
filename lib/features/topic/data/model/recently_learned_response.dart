import 'package:final_flashcard/features/learning/data/models/topic_learning_statistics.dart';
import 'package:final_flashcard/features/learning/data/models/vocabulary_statistics.dart';

class RecentlyLearnedResponse {
  final TopicLearningStatisticsModel? topicLearningStatistics;
  final List<VocabularyStatisticsModel>? vocabularyStatistics;

  RecentlyLearnedResponse({
    required this.topicLearningStatistics,
    required this.vocabularyStatistics,
  });

  factory RecentlyLearnedResponse.fromJson(Map<String, dynamic> json) {
    return RecentlyLearnedResponse(
      topicLearningStatistics: json['topicLearningStatistics'] != null
          ? TopicLearningStatisticsModel.fromJson(
              json['topicLearningStatistics'],
            )
          : null,
      vocabularyStatistics: json['vocabularyStatistics'] != null
          ? (json['vocabularyStatistics'] as List)
              .map((e) => VocabularyStatisticsModel.fromJson(e))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'topicLearningStatistics': topicLearningStatistics?.toJson(),
      'vocabularyStatistics':
          vocabularyStatistics?.map((e) => e.toJson()).toList(),
    };
  }
}
