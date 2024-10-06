part of 'folder_to_topic_bloc.dart';

@freezed
class FolderToTopicStateData with _$FolderToTopicStateData {
  const factory FolderToTopicStateData({
    Topic? topic,
    @Default([]) List<Folder> folders,
    @Default([]) List<Folder> selectedFolders,
    @Default('') String error,
  }) = _FolderToTopicStateData;
}

@freezed
abstract class FolderToTopicState with _$FolderToTopicState {
  const factory FolderToTopicState.initial(FolderToTopicStateData data) =
      FolderToTopicInitial;
  const factory FolderToTopicState.loading(FolderToTopicStateData data) =
      FolderToTopicLoading;
  const factory FolderToTopicState.loaded(FolderToTopicStateData data) =
      FolderToTopicLoaded;
  const factory FolderToTopicState.error(FolderToTopicStateData data) =
      FolderToTopicError;
  const factory FolderToTopicState.folderCreatedSuccessfully(
      FolderToTopicStateData data) = FolderCreatedSuccessfully;
  const factory FolderToTopicState.folderCreationFailed(
      FolderToTopicStateData data) = FolderCreationFailed;
  const factory FolderToTopicState.addFolderToTopicSuccess(
      FolderToTopicStateData data) = AddFolderToTopicSuccess;
  const factory FolderToTopicState.addFolderToTopicFailed(
      FolderToTopicStateData data) = AddFolderToTopicFailed;
}
