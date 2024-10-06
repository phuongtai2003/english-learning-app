part of 'folder_detail_bloc.dart';

@freezed
abstract class FolderDetailEvent with _$FolderDetailEvent {
  const factory FolderDetailEvent.loadFolderDetail({
    required int folderId,
  }) = LoadFolderDetail;
  const factory FolderDetailEvent.removeTopicFromFolder({
    required int topicId,
  }) = RemoveTopicFromFolder;
  const factory FolderDetailEvent.editFolder({
    required String folderName,
    required String folderDescription,
  }) = EditFolder;
  const factory FolderDetailEvent.removeFolder() = RemoveFolder;
}
