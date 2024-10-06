part of 'folder_bloc.dart';

@freezed
class FolderStateData with _$FolderStateData {
  const factory FolderStateData({
    @Default('') String error,
    @Default([]) List<Folder> folders,
  }) = _FolderStateData;
}

@freezed
abstract class FolderState with _$FolderState {
  const factory FolderState.initial(FolderStateData data) = FolderInitial;
  const factory FolderState.loading(FolderStateData data) = FolderLoading;
  const factory FolderState.loaded(FolderStateData data) = FolderLoaded;
  const factory FolderState.error(FolderStateData data) = FolderError;
  const factory FolderState.addFolderSuccess(FolderStateData data) =
      FolderAddFolderSuccess;
      const factory FolderState.addFolderFailure(FolderStateData data) = FolderAddFolderFailure;
}
