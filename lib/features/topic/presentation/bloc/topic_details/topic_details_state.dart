part of 'topic_details_bloc.dart';

@freezed
abstract class TopicDetailsStateData with _$TopicDetailsStateData {
  const factory TopicDetailsStateData({
    Topic? topic,
    int? userId,
    AddTopicBloc? addTopicBloc,
    @Default([]) List<Vocabulary> favoriteVocabularies,
    @Default([]) List<VocabularyStatistics> vocabularyStatistics,
    @Default('') String error,
    @Default(-1) int vocabSpeakingIndex,
    @Default(false) isTermSpeaking,
    @Default(false) isDefinitionSpeaking,
    @Default(false) showLearnButtonBottom,
    @Default(true) bool learnAll,
  }) = _TopicDetailsStateData;
}

@freezed
abstract class TopicDetailsState with _$TopicDetailsState {
  const factory TopicDetailsState.initial(TopicDetailsStateData data) =
      TopicDetailsInitial;
  const factory TopicDetailsState.loading(TopicDetailsStateData data) =
      TopicDetailsLoading;
  const factory TopicDetailsState.loaded(TopicDetailsStateData data) =
      TopicDetailsLoaded;
  const factory TopicDetailsState.error(TopicDetailsStateData data) =
      TopicDetailsError;
  const factory TopicDetailsState.downloadSuccess(TopicDetailsStateData data) =
      TopicDetailsDownloadSuccess;
  const factory TopicDetailsState.downloadFailure(TopicDetailsStateData data) =
      TopicDetailsDownloadFailure;
  const factory TopicDetailsState.downloadLoading(TopicDetailsStateData data) =
      TopicDetailsDownloadLoading;
  const factory TopicDetailsState.deleteTopicError(TopicDetailsStateData data) =
      TopicDetailsDeleteTopicError;
  const factory TopicDetailsState.deleteTopicSuccess(
      TopicDetailsStateData data) = TopicDetailsDeleteTopicSuccess;
  const factory TopicDetailsState.exportToCsvSuccess(
      TopicDetailsStateData data) = TopicDetailsExportToCsvSuccess;
  const factory TopicDetailsState.exportToCsvFailed(
      TopicDetailsStateData data) = TopicDetailsExportToCsvFailed;
}
