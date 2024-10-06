import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/features/learning/domain/entities/topic_learning_statistics.dart';

abstract class TopicLearningRepository {
  ResultFuture<TopicLearningStatistics> updateLearningStatistics({
    required List<int> learnedVocabularyIds,
    required List<int> notLearnedVocabularyIds,
    required int topicId,
    required int secondsSpent,
  });
}
