part of 'topic_bloc.dart';

@freezed
abstract class TopicStateData with _$TopicStateData {
  const factory TopicStateData({
    TopicLearningStatisticsModel? recentTopicLearningStatisticsModel,
    @Default([]) List<VocabularyStatistics> recentVocabularyStatistics,
    @Default([]) List<Topic> topics,
    @Default([]) List<TopicLearningStatistics?> topicLearningStatistics,
    @Default([]) List<List<VocabularyStatistics>?> vocabularyStatistics,
    @Default('') String error,
    @Default([]) List<AddTopicBloc> addTopicBlocs,
  }) = _TopicStateData;
}

@freezed
abstract class TopicState with _$TopicState {
  const factory TopicState.initial(TopicStateData data) = TopicInitial;
  const factory TopicState.loading(TopicStateData data) = TopicLoading;
  const factory TopicState.loaded(TopicStateData data) = TopicLoaded;
  const factory TopicState.error(TopicStateData data) = TopicError;
  const factory TopicState.addPendingBloc(TopicStateData data) =
      TopicAddPendingBloc;
  const factory TopicState.removePendingBloc(TopicStateData data) =
      TopicRemovePendingBloc;
}
