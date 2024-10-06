import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/core/use_case/use_case.dart';
import 'package:final_flashcard/features/folder/domain/entities/folder.dart';
import 'package:final_flashcard/features/folder/domain/repository/folder_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetFolderDetailUseCase implements UseCaseWithParams<Folder, int> {
  final FolderRepository _folderRepository;

  GetFolderDetailUseCase(this._folderRepository);

  @override
  ResultFuture<Folder> call(int folderId) async {
    return await _folderRepository.getFolderDetail(folderId);
  }
}
