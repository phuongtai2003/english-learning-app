import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/core/use_case/use_case.dart';
import 'package:final_flashcard/features/folder/domain/repository/folder_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class RemoveFolderUseCase
    implements UseCaseWithParams<bool, RemoveFolderUseCaseParams> {
  final FolderRepository _folderRepository;

  RemoveFolderUseCase(this._folderRepository);
  @override
  ResultFuture<bool> call(RemoveFolderUseCaseParams params) async {
    return await _folderRepository.removeFolder(
      params.folderId,
    );
  }
}

class RemoveFolderUseCaseParams {
  final int folderId;

  const RemoveFolderUseCaseParams({
    required this.folderId,
  });
}
