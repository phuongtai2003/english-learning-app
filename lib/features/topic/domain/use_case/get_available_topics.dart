import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/core/use_case/use_case.dart';
import 'package:final_flashcard/features/topic/domain/entities/topic.dart';
import 'package:final_flashcard/features/topic/domain/repository/topic_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetAvailableTopicsUseCase implements UseCaseWithParams<List<Topic>, int> {
  final TopicRepository _topicRepository;

  GetAvailableTopicsUseCase(this._topicRepository);

  @override
  ResultFuture<List<Topic>> call(int params) async {
    return await _topicRepository.getAvailableTopics(params);
  }
}
