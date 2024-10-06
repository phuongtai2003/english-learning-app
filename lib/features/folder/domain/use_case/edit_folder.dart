import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/core/use_case/use_case.dart';
import 'package:final_flashcard/features/folder/domain/entities/folder.dart';
import 'package:final_flashcard/features/folder/domain/repository/folder_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class EditFolderUseCase
    implements UseCaseWithParams<Folder, EditFolderUseCaseParams> {
  final FolderRepository _folderRepository;

  EditFolderUseCase(this._folderRepository);
  @override
  ResultFuture<Folder> call(EditFolderUseCaseParams params) async {
    return await _folderRepository.editFolder(
      params.folderId,
      params.folderName,
      params.folderDescription,
    );
  }
}

class EditFolderUseCaseParams {
  final int folderId;
  final String folderName;
  final String folderDescription;

  const EditFolderUseCaseParams({
    required this.folderId,
    required this.folderName,
    required this.folderDescription,
  });
}
