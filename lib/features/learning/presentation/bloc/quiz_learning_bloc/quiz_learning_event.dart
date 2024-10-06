part of 'quiz_learning_bloc.dart';

@freezed
abstract class QuizLearningEvent with _$QuizLearningEvent {
  const factory QuizLearningEvent.initQuizLearning({
    required Topic topic,
    required List<Vocabulary> selectedVocabularies,
  }) = InitQuizLearning;
  const factory QuizLearningEvent.answerQuiz({
    required Vocabulary answer,
    required bool findDefinition,
    required bool isPromptTerm,
  }) = AnswerQuiz;
  const factory QuizLearningEvent.changeInstantFeedback({
    required bool instantFeedback,
  }) = ChangeInstantFeedback;
  const factory QuizLearningEvent.changeAnswerWith({
    required bool answerTerm,
    required bool answerDefinition,
  }) = ChangeAnswerWith;
  const factory QuizLearningEvent.changePromptWith({
    required bool promptTerm,
    required bool promptDefinition,
  }) = ChangePromptWith;
  const factory QuizLearningEvent.startQuiz({
    required int questionCount,
  }) = StartQuizEvent;
  const factory QuizLearningEvent.nextQuiz() = NextQuizEvent;
  const factory QuizLearningEvent.clearError() = ClearError;
  const factory QuizLearningEvent.updateLearningStatistic(
      {required int seconds}) = UpdateLearningStatistic;
}
