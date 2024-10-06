import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/core/use_case/use_case.dart';
import 'package:final_flashcard/features/learning/domain/entities/topic_learning_statistics.dart';
import 'package:final_flashcard/features/learning/domain/entities/vocabulary_statistics.dart';
import 'package:final_flashcard/features/topic/domain/entities/topic.dart';
import 'package:final_flashcard/features/topic/domain/repository/topic_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetUserTopicUseCase
    implements UseCaseWithoutParams<GetUserTopicsUseCaseResult> {
  final TopicRepository _topicRepository;

  GetUserTopicUseCase(this._topicRepository);

  @override
  ResultFuture<GetUserTopicsUseCaseResult> call() async {
    return await _topicRepository.getUserTopics();
  }
}

class GetUserTopicsUseCaseResult {
  final List<Topic> topics;
  final List<TopicLearningStatistics?> topicLearningStatistics;
  final List<List<VocabularyStatistics>?> vocabularyStatistics;

  GetUserTopicsUseCaseResult(
    this.topics,
    this.topicLearningStatistics,
    this.vocabularyStatistics,
  );
}
