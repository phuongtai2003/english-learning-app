part of 'folder_bloc.dart';

@freezed
abstract class FolderEvent with _$FolderEvent {
  const factory FolderEvent.loadFolder() = LoadFolder;
  const factory FolderEvent.addFolder(
      String folderName, String? folderDescription) = AddFolder;
}
