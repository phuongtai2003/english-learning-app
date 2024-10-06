import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/core/use_case/use_case.dart';
import 'package:final_flashcard/features/folder/domain/entities/folder.dart';
import 'package:final_flashcard/features/folder/domain/repository/folder_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetAvailableFoldersUseCase
    implements UseCaseWithParams<List<Folder>, int> {
  final FolderRepository _folderRepository;

  GetAvailableFoldersUseCase(this._folderRepository);

  @override
  ResultFuture<List<Folder>> call(int params) async {
    return await _folderRepository.getAvailableFolders(params);
  }
}
