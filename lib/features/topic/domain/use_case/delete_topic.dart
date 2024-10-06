import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/core/use_case/use_case.dart';
import 'package:final_flashcard/features/topic/domain/repository/topic_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DeleteTopicUseCase implements UseCaseWithParams<bool, int> {
  final TopicRepository _topicRepository;

  DeleteTopicUseCase(this._topicRepository);
  @override
  ResultFuture<bool> call(int params) async {
    return await _topicRepository.deleteTopic(params);
  }
}
