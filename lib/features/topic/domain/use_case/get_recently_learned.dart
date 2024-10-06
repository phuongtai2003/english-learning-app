import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/core/use_case/use_case.dart';
import 'package:final_flashcard/features/topic/data/model/recently_learned_response.dart';
import 'package:final_flashcard/features/topic/domain/repository/topic_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetRecentlyLearnedUseCase
    implements UseCaseWithoutParams<RecentlyLearnedResponse?> {
  final TopicRepository _topicRepository;

  GetRecentlyLearnedUseCase(this._topicRepository);

  @override
  ResultFuture<RecentlyLearnedResponse?> call() async {
    return await _topicRepository.getRecentlyLearned();
  }
}
