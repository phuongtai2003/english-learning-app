import 'package:equatable/equatable.dart';
import 'package:final_flashcard/features/learning/domain/entities/topic_learning_statistics.dart';
import 'package:final_flashcard/features/learning/domain/entities/vocabulary_statistics.dart';

class Rankings extends Equatable {
  final int? rank;
  final TopicLearningStatistics? topicLearningStatistics;
  final List<VocabularyStatistics>? vocabularyStatistics;

  const Rankings({
    this.rank,
    this.topicLearningStatistics,
    this.vocabularyStatistics,
  });

  @override
  List<Object?> get props =>
      [rank, topicLearningStatistics, vocabularyStatistics];
}
