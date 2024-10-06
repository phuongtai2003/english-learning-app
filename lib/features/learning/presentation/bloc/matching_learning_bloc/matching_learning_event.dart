part of 'matching_learning_bloc.dart';

@freezed
abstract class MatchingLearningEvent with _$MatchingLearningEvent {
  const factory MatchingLearningEvent.initMatchingLearning({
    required Topic topic,
    required List<Vocabulary> selectedVocabularies,
  }) = InitMatchingLearning;
  const factory MatchingLearningEvent.increaseTimer() = IncreaseTimerEvent;
  const factory MatchingLearningEvent.startMatching() = StartMatchingEvent;
  const factory MatchingLearningEvent.selectMatchingCard({
    required int index,
  }) = SelectMatchingCard;
  const factory MatchingLearningEvent.nextMatchingPage() = NextMatchingPage;
  const factory MatchingLearningEvent.updateLearningStatistic() =
      UpdateLearningStatistic;
}
