part of 'flashcard_learning_bloc.dart';

@freezed
abstract class FlashcardLearningEvent with _$FlashcardLearningEvent {
  const factory FlashcardLearningEvent.initFlashcardLearning({
    required Topic topic,
    required List<Vocabulary> selectedVocabularies,
  }) = InitFlashcardLearning;
  const factory FlashcardLearningEvent.nextFlashcard({
    required bool isLearned,
  }) = NextFlashcard;
  const factory FlashcardLearningEvent.previousFlashcard() = PreviousFlashcard;
  const factory FlashcardLearningEvent.speakTerm(int index, bool isSpeaking) =
      FlashcardSpeakTerm;
  const factory FlashcardLearningEvent.speakDefinition(
      int index, bool isSpeaking) = FlashcardSpeakDefinition;
  const factory FlashcardLearningEvent.shuffleFlashcards() =
      ShuffleFlashcardsToggle;
  const factory FlashcardLearningEvent.autoSpeakToggle() = AutoSpeakToggle;
  const factory FlashcardLearningEvent.autoPlayToggle() = AutoPlayToggle;
  const factory FlashcardLearningEvent.updateLearningStatistics({
    required int timeSpent,
  }) = UpdateLearningStatistics;
}
