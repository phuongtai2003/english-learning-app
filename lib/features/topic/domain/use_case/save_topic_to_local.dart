import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/core/use_case/use_case.dart';
import 'package:final_flashcard/features/topic/domain/repository/topic_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SaveTopicToLocalUseCase implements UseCaseWithParams<bool, DataMap> {
  final TopicRepository repository;

  SaveTopicToLocalUseCase(this.repository);

  @override
  ResultFuture<bool> call(DataMap params) async {
    return await repository.downloadTopicToLocal(
      params['topic'],
      params['userId'],
    );
  }
}
