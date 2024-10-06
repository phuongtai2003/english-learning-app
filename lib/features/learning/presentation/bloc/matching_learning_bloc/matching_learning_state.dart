part of 'matching_learning_bloc.dart';

@freezed
abstract class MatchingLearningStateData with _$MatchingLearningStateData {
  const factory MatchingLearningStateData({
    Topic? topic,
    @Default('') String error,
    @Default(0) int currentPageIndex,
    @Default(0) int totalPage,
    @Default([]) List<Vocabulary> vocabularies,
    @Default([]) List<MatchingCard> matchingCards,
    @Default(0) int seconds,
  }) = _MatchingLearningStateData;
}

@freezed
abstract class MatchingLearningState with _$MatchingLearningState {
  const factory MatchingLearningState.initial(MatchingLearningStateData data) =
      MatchingLearningInitial;
  const factory MatchingLearningState.loading(MatchingLearningStateData data) =
      MatchingLearningLoading;
  const factory MatchingLearningState.loaded(MatchingLearningStateData data) =
      MatchingLearningLoaded;
  const factory MatchingLearningState.error(MatchingLearningStateData data) =
      MatchingLearningError;
  const factory MatchingLearningState.finished(MatchingLearningStateData data) =
      MatchingLearningFinished;
  const factory MatchingLearningState.correctAnswer(
      MatchingLearningStateData data) = MatchingLearningCorrectAnswer;
  const factory MatchingLearningState.wrongAnswer(
      MatchingLearningStateData data) = MatchingLearningWrongAnswer;
  const factory MatchingLearningState.updatedLearningStatistic(
          MatchingLearningStateData data) =
      MatchingLearningUpdatedLearningStatistic;
}
