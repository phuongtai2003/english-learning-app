import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/core/use_case/use_case.dart';
import 'package:final_flashcard/features/folder/domain/entities/folder.dart';
import 'package:final_flashcard/features/folder/domain/repository/folder_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AddFoldersToTopicUseCase
    implements UseCaseWithParams<List<Folder>, AddFoldersToTopicParams> {
  final FolderRepository _folderRepository;

  AddFoldersToTopicUseCase(this._folderRepository);

  @override
  ResultFuture<List<Folder>> call(AddFoldersToTopicParams params) async {
    return await _folderRepository.addFolderToTopic(
      params.topicId,
      params.folderIds,
    );
  }
}

class AddFoldersToTopicParams {
  final int topicId;
  final List<int> folderIds;

  AddFoldersToTopicParams(this.topicId, this.folderIds);
}
