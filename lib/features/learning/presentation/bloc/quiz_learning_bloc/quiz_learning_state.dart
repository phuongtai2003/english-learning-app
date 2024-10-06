part of 'quiz_learning_bloc.dart';

@freezed
abstract class QuizLearningStateData with _$QuizLearningStateData {
  const factory QuizLearningStateData({
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
  }) = _QuizLearningStateData;
}

@freezed
abstract class QuizLearningState with _$QuizLearningState {
  const factory QuizLearningState.initial(QuizLearningStateData data) =
      QuizLearningInitial;
  const factory QuizLearningState.loading(QuizLearningStateData data) =
      QuizLearningLoading;
  const factory QuizLearningState.settings(QuizLearningStateData data) =
      QuizLearningSettings;
  const factory QuizLearningState.loaded(QuizLearningStateData data) =
      QuizLearningLoaded;
  const factory QuizLearningState.error(QuizLearningStateData data) =
      QuizLearningError;
  const factory QuizLearningState.correctAnswer(QuizLearningStateData data) =
      QuizLearningCorrectAnswer;
  const factory QuizLearningState.wrongAnswer(QuizLearningStateData data) =
      QuizLearningWrongAnswer;
  const factory QuizLearningState.finished(QuizLearningStateData data) =
      QuizLearningFinished;
  const factory QuizLearningState.updateStatistic(QuizLearningStateData data) =
      QuizLearningUpdateStatistic;
}
