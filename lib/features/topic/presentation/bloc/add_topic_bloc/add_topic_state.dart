part of 'add_topic_bloc.dart';

@freezed
class AddTopicStateData with _$AddTopicStateData {
  const factory AddTopicStateData({
    Topic? currentTopic,
    @Default('') String error,
    @Default(0) int flashcardIndex,
    @Default([]) List<FlashCardWidget> flashcardsList,
    @Default([]) List<File?> images,
    @Default('en') String termLanguage,
    @Default('en') String definitionLanguage,
    @Default(false) bool isTopicPublic,
    @Default(true) bool isNewTopic,
  }) = _AddTopicStateData;
}

@freezed
abstract class AddTopicState with _$AddTopicState {
  const factory AddTopicState.initial(AddTopicStateData data) = AddTopicInitial;
  const factory AddTopicState.loading(AddTopicStateData data) = AddTopicLoading;
  const factory AddTopicState.loaded(AddTopicStateData data) = AddTopicLoaded;
  const factory AddTopicState.error(AddTopicStateData data) = AddTopicError;
  const factory AddTopicState.changeIndex(AddTopicStateData data) =
      AddTopicChangeFlashcardIndex;
  const factory AddTopicState.addFlashcard(AddTopicStateData data) =
      AddTopicAddFlashcard;
  const factory AddTopicState.removeFlashcard(AddTopicStateData data) =
      AddTopicRemoveFlashcard;
  const factory AddTopicState.pickImage(AddTopicStateData data) =
      AddTopicPickImage;
  const factory AddTopicState.removeImage(AddTopicStateData data) =
      AddTopicRemoveImage;
  const factory AddTopicState.changeTermLanguage(AddTopicStateData data) =
      AddTopicChangeTermLanguage;
  const factory AddTopicState.changeDefinitionLanguage(AddTopicStateData data) =
      AddTopicChangeDefinitionLanguage;
  const factory AddTopicState.changeTopicPublic(AddTopicStateData data) =
      AddTopicChangeTopicPublic;
  const factory AddTopicState.addTopicSuccess(AddTopicStateData data) =
      AddTopicSuccess;
  const factory AddTopicState.deleteTopicSuccess(AddTopicStateData data) =
      DeleteTopicSuccess;
  const factory AddTopicState.deleteTopicError(AddTopicStateData data) =
      DeleteTopicError;
  const factory AddTopicState.updateTopicSuccess(AddTopicStateData data) =
      UpdateTopicSuccess;
  const factory AddTopicState.updateTopicError(AddTopicStateData data) =
      UpdateTopicError;
  const factory AddTopicState.importCsvFileSuccess(AddTopicStateData data) =
      ImportCsvFileSuccess;
  const factory AddTopicState.importCsvFileError(AddTopicStateData data) =
      ImportCsvFileError;
}
