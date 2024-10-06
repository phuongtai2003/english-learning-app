part of 'add_topic_folder_bloc.dart';

@freezed
abstract class AddTopicFolderStateData with _$AddTopicFolderStateData {
  const factory AddTopicFolderStateData({
    @Default([]) List<Topic> availableTopics,
    @Default([]) List<Topic> selectedTopics,
    Folder? folder,
    @Default('') String error,
  }) = _AddTopicFolderStateData;
}

@freezed
abstract class AddTopicFolderState with _$AddTopicFolderState {
  const factory AddTopicFolderState.initial(AddTopicFolderStateData data) =
      AddTopicFolderInitial;
  const factory AddTopicFolderState.loading(AddTopicFolderStateData data) =
      AddTopicFolderLoading;
  const factory AddTopicFolderState.loaded(AddTopicFolderStateData data) =
      AddTopicFolderLoaded;
  const factory AddTopicFolderState.error(AddTopicFolderStateData data) =
      AddTopicFolderError;
  const factory AddTopicFolderState.addedSuccess(AddTopicFolderStateData data) =
      AddTopicsSuccess;
  const factory AddTopicFolderState.addedError(AddTopicFolderStateData data) =
      AddTopicsError;
}
