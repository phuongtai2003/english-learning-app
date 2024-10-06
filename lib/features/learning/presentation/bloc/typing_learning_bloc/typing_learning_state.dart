part of 'typing_learning_bloc.dart';

@freezed
abstract class TypingLearningStateData with _$TypingLearningStateData {
  const factory TypingLearningStateData({
    Topic? topic,
    @Default('') String error,
    @Default(0) int currentQuizIndex,
    @Default([]) List<Vocabulary> vocabularies,
    @Default([]) List<Quiz> quizzes,
    @Default(true) bool instantFeedback,
    @Default(true) bool promptDefinition,
    @Default(true) bool promptTerm,
    @Default(true) bool answerTerm,
    @Default(true) bool answerDefinition,
    @Default(true) bool shuffle,
  }) = _TypingLearningStateData;
}

@freezed
abstract class TypingLearningState with _$TypingLearningState {
  const factory TypingLearningState.initial(TypingLearningStateData data) =
      TypingLearningInitial;
  const factory TypingLearningState.loading(TypingLearningStateData data) =
      TypingLearningLoading;
  const factory TypingLearningState.settings(TypingLearningStateData data) =
      TypingLearningSettings;
  const factory TypingLearningState.loaded(TypingLearningStateData data) =
      TypingLearningLoaded;
  const factory TypingLearningState.error(TypingLearningStateData data) =
      TypingLearningError;
  const factory TypingLearningState.correctAnswer(
      TypingLearningStateData data) = TypingLearningCorrectAnswer;
  const factory TypingLearningState.wrongAnswer(TypingLearningStateData data) =
      TypingLearningWrongAnswer;
  const factory TypingLearningState.finished(TypingLearningStateData data) =
      TypingLearningFinished;
  const factory TypingLearningState.updatedLearningStatistics(
      TypingLearningStateData data) = TypingLearningUpdatedLearningStatistics;
}
