part of 'folder_detail_bloc.dart';

@freezed
class FolderDetailStateData with _$FolderDetailStateData {
  const factory FolderDetailStateData({
    Folder? folder,
    @Default('') String error,
  }) = _FolderDetailStateData;
}

@freezed
abstract class FolderDetailState with _$FolderDetailState {
  const factory FolderDetailState.initial(FolderDetailStateData data) =
      FolderDetailInitial;
  const factory FolderDetailState.loading(FolderDetailStateData data) =
      FolderDetailLoading;
  const factory FolderDetailState.error(FolderDetailStateData data) =
      FolderDetailError;
  const factory FolderDetailState.loaded(FolderDetailStateData data) =
      FolderDetailLoaded;
  const factory FolderDetailState.removedTopicSuccess(
      FolderDetailStateData data) = FolderDetailRemovedTopicSuccess;
  const factory FolderDetailState.removedTopicError(
      FolderDetailStateData data) = FolderDetailRemovedTopicError;
  const factory FolderDetailState.editFolderSuccess(
      FolderDetailStateData data) = FolderDetailEditFolderSuccess;
  const factory FolderDetailState.editFolderError(FolderDetailStateData data) =
      FolderDetailEditFolderError;
  const factory FolderDetailState.editFolderLoading(
      FolderDetailStateData data) = FolderDetailEditFolderLoading;
  const factory FolderDetailState.removeFolderSuccess(
      FolderDetailStateData data) = FolderDetailRemoveFolderSuccess;
  const factory FolderDetailState.removeFolderError(
      FolderDetailStateData data) = FolderDetailRemoveFolderError;
  const factory FolderDetailState.removeFolderLoading(
      FolderDetailStateData data) = FolderDetailRemoveFolderLoading;
}
