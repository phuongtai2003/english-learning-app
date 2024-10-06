import 'package:final_flashcard/features/learning/data/models/vocabulary_statistics.dart';
import 'package:final_flashcard/features/topic/data/model/topic.dart';
import 'package:final_flashcard/features/topic/data/model/vocabulary.dart';

class TopicDetailsResponse {
  final TopicModel topic;
  final List<VocabularyModel> favoriteVocabularies;
  final List<VocabularyStatisticsModel> vocabularyStatistics;

  TopicDetailsResponse({
    required this.topic,
    required this.favoriteVocabularies,
    required this.vocabularyStatistics,
  });

  factory TopicDetailsResponse.fromJson(Map<String, dynamic> json) {
    return TopicDetailsResponse(
      topic: TopicModel.fromJson(json['topic']),
      favoriteVocabularies: List<VocabularyModel>.from(
        json['favoriteVocabularies'].map(
          (x) => VocabularyModel.fromJson(x),
        ),
      ),
      vocabularyStatistics: List<VocabularyStatisticsModel>.from(
        json['vocabularyStatistics'].map(
          (x) => VocabularyStatisticsModel.fromJson(x),
        ),
      ),
    );
  }
}
