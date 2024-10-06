import 'package:equatable/equatable.dart';
import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/core/use_case/use_case.dart';
import 'package:final_flashcard/features/folder/domain/entities/folder.dart';
import 'package:final_flashcard/features/folder/domain/repository/folder_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class RemoveTopicFromFolderUseCase
    implements UseCaseWithParams<Folder, RemoveTopicFromFolderUseCaseParams> {
  final FolderRepository _folderRepository;

  RemoveTopicFromFolderUseCase(this._folderRepository);

  @override
  ResultFuture<Folder> call(RemoveTopicFromFolderUseCaseParams params) async {
    return await _folderRepository.removeTopicFromFolder(
        params.folderId, params.topicId);
  }
}

class RemoveTopicFromFolderUseCaseParams extends Equatable {
  final int folderId;
  final int topicId;

  const RemoveTopicFromFolderUseCaseParams(this.folderId, this.topicId);

  @override
  List<Object?> get props => [folderId, topicId];
}
