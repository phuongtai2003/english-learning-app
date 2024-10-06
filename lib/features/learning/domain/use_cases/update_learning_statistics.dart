import 'package:equatable/equatable.dart';
import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/core/use_case/use_case.dart';
import 'package:final_flashcard/features/learning/domain/entities/topic_learning_statistics.dart';
import 'package:final_flashcard/features/learning/domain/repository/topic_learning_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class UpdateLearningStatisticsUseCase
    implements
        UseCaseWithParams<TopicLearningStatistics,
            UpdateLearningStatisticsParams> {
  final TopicLearningRepository _topicLearningRepository;

  UpdateLearningStatisticsUseCase(this._topicLearningRepository);

  @override
  ResultFuture<TopicLearningStatistics> call(
      UpdateLearningStatisticsParams params) async {
    return await _topicLearningRepository.updateLearningStatistics(
      learnedVocabularyIds: params.learnedVocabularyIds,
      notLearnedVocabularyIds: params.notLearnedVocabularyIds,
      topicId: params.topicId,
      secondsSpent: params.secondsSpent,
    );
  }
}

class UpdateLearningStatisticsParams extends Equatable {
  final List<int> learnedVocabularyIds;
  final List<int> notLearnedVocabularyIds;
  final int topicId;
  final int secondsSpent;

  const UpdateLearningStatisticsParams({
    required this.learnedVocabularyIds,
    required this.notLearnedVocabularyIds,
    required this.topicId,
    required this.secondsSpent,
  });

  @override
  List<Object?> get props =>
      [learnedVocabularyIds, notLearnedVocabularyIds, topicId, secondsSpent];
}
