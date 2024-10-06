import 'package:equatable/equatable.dart';
import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/core/use_case/use_case.dart';
import 'package:final_flashcard/features/topic/domain/entities/topic.dart';
import 'package:final_flashcard/features/topic/domain/repository/topic_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AddTopicsToFolderUseCase
    implements UseCaseWithParams<List<Topic>, AddTopicsToFolderParams> {
  final TopicRepository _topicRepository;

  AddTopicsToFolderUseCase(this._topicRepository);

  @override
  ResultFuture<List<Topic>> call(AddTopicsToFolderParams params) async {
    return await _topicRepository.addTopicsToFolder(
      params.topicIds,
      params.folderId,
    );
  }
}

class AddTopicsToFolderParams extends Equatable {
  final List<int> topicIds;
  final int folderId;

  const AddTopicsToFolderParams(this.topicIds, this.folderId);

  @override
  List<Object?> get props => [topicIds, folderId];
}
