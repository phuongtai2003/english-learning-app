import 'package:final_flashcard/features/learning/data/models/topic_learning_statistics.dart';
import 'package:final_flashcard/features/learning/data/models/vocabulary_statistics.dart';
import 'package:final_flashcard/features/topic/data/model/topic.dart';

class GetTopicsResponse {
  final List<TopicModel> topics;
  final List<TopicLearningStatisticsModel?> topicLearningStatistics;
  final List<List<VocabularyStatisticsModel>?> vocabularyStatistics;

  GetTopicsResponse(
    this.topics,
    this.topicLearningStatistics,
    this.vocabularyStatistics,
  );

  factory GetTopicsResponse.fromJson(Map<String, dynamic> json) {
    return GetTopicsResponse(
      (json['topics'] as List)
          .map((e) => TopicModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['topicLearningStatistics'] as List)
          .map((e) => e != null
              ? TopicLearningStatisticsModel.fromJson(e as Map<String, dynamic>)
              : null)
          .toList(),
      (json['vocabularyStatistics'] as List)
          .map((e) => e != null
              ? (e as List)
                  .map((e) => VocabularyStatisticsModel.fromJson(
                      e as Map<String, dynamic>))
                  .toList()
              : null)
          .toList(),
    );
  }
}
