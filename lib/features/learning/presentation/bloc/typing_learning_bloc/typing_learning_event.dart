part of 'typing_learning_bloc.dart';

@freezed
abstract class TypingLearningEvent with _$TypingLearningEvent {
  const factory TypingLearningEvent.initTypingLearning({
    required Topic topic,
    required List<Vocabulary> selectedVocabularies,
  }) = InitTypingLearning;
  const factory TypingLearningEvent.changeInstantFeedback({
    required bool instantFeedback,
  }) = ChangeTypingInstantFeedback;
  const factory TypingLearningEvent.changeAnswerWith({
    required bool answerTerm,
    required bool answerDefinition,
  }) = ChangeTypingAnswerWith;
  const factory TypingLearningEvent.changePromptWith({
    required bool promptTerm,
    required bool promptDefinition,
  }) = ChangeTypingPromptWith;
  const factory TypingLearningEvent.changeShuffle({
    required bool shuffle,
  }) = ChangeTypingShuffle;
  const factory TypingLearningEvent.answerTypingQuiz({
    required String answer,
    required bool findDefinition,
    required bool isPromptTerm,
  }) = AnswerTypingQuiz;
  const factory TypingLearningEvent.startQuiz({
    required int questionCount,
  }) = TypingStartQuiz;
  const factory TypingLearningEvent.nextQuiz() = TypingNextQuiz;
  const factory TypingLearningEvent.clearError() = TypingClearError;
  const factory TypingLearningEvent.updateLearningStatistics({
    required int seconds,
  }) = UpdateTypingLearningStatistics;
}
