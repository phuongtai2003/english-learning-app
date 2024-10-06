part of 'flashcard_learning_bloc.dart';

@freezed
abstract class FlashcardLearningStateData with _$FlashcardLearningStateData {
  const factory FlashcardLearningStateData({
    Topic? topic,
    @Default('') String error,
    @Default([]) List<Vocabulary> topicVocabularies,
    @Default([]) List<Vocabulary> topicVocabulariesShuffled,
    @Default(0) int currentFlashcardIndex,
    @Default(0) int totalFlashcard,
    @Default(-1) int speakingFlashcardIndex,
    @Default(false) bool isTermSpeaking,
    @Default(false) bool isDefinitionSpeaking,
    @Default(false) bool shuffleFlashcards,
    @Default(false) bool autoSpeak,
    @Default([]) List<Vocabulary> learnedVocabularies,
    @Default([]) List<Vocabulary> notLearnedVocabularies,
    @Default([]) List<FlipCardController> flipCardControllers,
    @Default(false) bool isAutoPlay,
    @Default(false) bool isCompleted,
  }) = _FlashcardLearningStateData;
}

@freezed
abstract class FlashcardLearningState with _$FlashcardLearningState {
  const factory FlashcardLearningState.initial(
      FlashcardLearningStateData data) = FlashcardLearningInitial;
  const factory FlashcardLearningState.loading(
      FlashcardLearningStateData data) = FlashcardLearningLoading;
  const factory FlashcardLearningState.loaded(FlashcardLearningStateData data) =
      FlashcardLearningLoaded;
  const factory FlashcardLearningState.error(FlashcardLearningStateData data) =
      FlashcardLearningError;
  const factory FlashcardLearningState.completed(
      FlashcardLearningStateData data) = FlashcardLearningCompleted;
  const factory FlashcardLearningState.updateCompleted(
      FlashcardLearningStateData data) = FlashcardLearningUpdateCompleted;
}
