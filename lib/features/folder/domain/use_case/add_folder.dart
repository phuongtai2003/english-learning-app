import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/core/use_case/use_case.dart';
import 'package:final_flashcard/features/folder/domain/entities/folder.dart';
import 'package:final_flashcard/features/folder/domain/repository/folder_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AddFolderUseCase implements UseCaseWithParams<Folder, AddFolderParams> {
  final FolderRepository _folderRepository;

  AddFolderUseCase(this._folderRepository);

  @override
  ResultFuture<Folder> call(AddFolderParams params) async {
    return await _folderRepository.addFolder(
      params.folderName,
      params.folderDescription,
    );
  }
}

class AddFolderParams {
  final String folderName;
  final String? folderDescription;

  AddFolderParams({
    required this.folderName,
    this.folderDescription,
  });
}
