import 'package:final_flashcard/features/learning/domain/entities/matching_card.dart';
import 'package:final_flashcard/features/learning/domain/use_cases/update_learning_statistics.dart';
import 'package:final_flashcard/features/topic/domain/entities/topic.dart';
import 'package:final_flashcard/features/topic/domain/entities/vocabulary.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get/get.dart';

part 'matching_learning_event.dart';
part 'matching_learning_state.dart';
part 'matching_learning_bloc.freezed.dart';

class MatchingLearningBloc
    extends Bloc<MatchingLearningEvent, MatchingLearningState> {
  final UpdateLearningStatisticsUseCase _updateLearningStatisticsUseCase;
  MatchingLearningBloc(
    this._updateLearningStatisticsUseCase,
  ) : super(const MatchingLearningState.initial(MatchingLearningStateData())) {
    on<InitMatchingLearning>(_onInitMatchingLearning);
    on<IncreaseTimerEvent>(_onIncreaseTimerEvent);
    on<StartMatchingEvent>(_onStartMatchingEvent);
    on<SelectMatchingCard>(_onSelectMatchingCard);
    on<NextMatchingPage>(_onNextMatchingPage);
    on<UpdateLearningStatistic>(_onUpdateLearningStatistic);
  }

  void _onInitMatchingLearning(
      InitMatchingLearning event, Emitter<MatchingLearningState> emit) {
    final List<MatchingCard> matchingCards = [];
    final int totalPage = (event.selectedVocabularies.length / 6).ceil();
    for (int i = 0; i < totalPage; i++) {
      final List<MatchingCard> subCardsList = [];
      final int maxIndex =
          (event.selectedVocabularies.length - i * 6).clamp(0, 6);
      for (int j = 0; j < maxIndex; j++) {
        final Vocabulary vocabulary = event.selectedVocabularies[i * 6 + j];
        subCardsList.addAll(
          [
            MatchingCard(
              vocabId: vocabulary.id,
              image: vocabulary.image,
              isTerm: true,
              isSelected: false,
              text: vocabulary.term,
              isAnsweredCorrectly: false,
            ),
            MatchingCard(
              vocabId: vocabulary.id,
              image: vocabulary.image,
              isTerm: false,
              isSelected: false,
              text: vocabulary.definition,
              isAnsweredCorrectly: false,
            ),
          ],
        );
      }
      subCardsList.shuffle();
      matchingCards.addAll(subCardsList);
    }

    emit(
      MatchingLearningState.initial(
        state.data.copyWith(
          topic: event.topic,
          currentPageIndex: 0,
          matchingCards: matchingCards,
          vocabularies: event.selectedVocabularies,
          totalPage: totalPage,
        ),
      ),
    );
  }

  void _onIncreaseTimerEvent(
      IncreaseTimerEvent event, Emitter<MatchingLearningState> emit) {
    emit(
      MatchingLearningState.loaded(
        state.data.copyWith(
          seconds: state.data.seconds + 1,
        ),
      ),
    );
  }

  void _onStartMatchingEvent(
      StartMatchingEvent event, Emitter<MatchingLearningState> emit) {
    emit(
      MatchingLearningState.loaded(
        state.data.copyWith(
          currentPageIndex: 0,
        ),
      ),
    );
  }

  void _onSelectMatchingCard(
      SelectMatchingCard event, Emitter<MatchingLearningState> emit) {
    final List<MatchingCard> matchingCards = [...state.data.matchingCards];

    final intStartIndex = state.data.currentPageIndex * 12;
    final intEndIndex =
        (state.data.currentPageIndex * 12 + 12).clamp(0, matchingCards.length);

    final subMatchingCards = matchingCards.sublist(intStartIndex, intEndIndex);

    final selectedCard = subMatchingCards[event.index - intStartIndex];
    final otherSelectedCard = subMatchingCards.firstWhereOrNull(
      (element) => element.isSelected == true,
    );

    if (otherSelectedCard != null) {
      final int otherIndex = matchingCards.indexOf(otherSelectedCard);
      if (otherSelectedCard.vocabId == selectedCard.vocabId &&
          otherIndex != event.index) {
        final newOtherSelectedCard = otherSelectedCard.copyWith(
          isAnsweredCorrectly: true,
          isSelected: false,
        );
        final newSelectedCard = selectedCard.copyWith(
          isAnsweredCorrectly: true,
          isSelected: false,
        );
        subMatchingCards[otherIndex - intStartIndex] = newOtherSelectedCard;
        subMatchingCards[event.index - intStartIndex] = newSelectedCard;
        matchingCards[otherIndex] = newOtherSelectedCard;
        matchingCards[event.index] = newSelectedCard;
        final isAllAnsweredCorrectly = subMatchingCards.every(
          (element) => element.isAnsweredCorrectly ?? false,
        );
        if (state.data.currentPageIndex == state.data.totalPage - 1 &&
            isAllAnsweredCorrectly) {
          emit(
            MatchingLearningState.finished(
              state.data.copyWith(
                matchingCards: matchingCards,
              ),
            ),
          );
        } else if (isAllAnsweredCorrectly) {
          add(
            const NextMatchingPage(),
          );
        } else {
          emit(
            MatchingLearningState.correctAnswer(
              state.data.copyWith(
                matchingCards: matchingCards,
              ),
            ),
          );
        }
      } else if (otherIndex == event.index) {
        final newSelectedCard = selectedCard.copyWith(
          isSelected: false,
        );
        matchingCards[event.index] = newSelectedCard;
        emit(
          MatchingLearningState.loaded(
            state.data.copyWith(
              matchingCards: matchingCards,
            ),
          ),
        );
      } else {
        final newOtherSelectedCard = otherSelectedCard.copyWith(
          isSelected: false,
        );
        final newSelectedCard = selectedCard.copyWith(
          isSelected: false,
        );
        matchingCards[otherIndex] = newOtherSelectedCard;
        matchingCards[event.index] = newSelectedCard;
        emit(
          MatchingLearningState.wrongAnswer(
            state.data.copyWith(
              matchingCards: matchingCards,
            ),
          ),
        );
      }
    } else {
      final newSelectedCard = selectedCard.copyWith(
        isSelected: true,
      );
      matchingCards[event.index] = newSelectedCard;
      emit(
        MatchingLearningState.loaded(
          state.data.copyWith(
            matchingCards: matchingCards,
          ),
        ),
      );
    }
  }

  void _onNextMatchingPage(
      NextMatchingPage event, Emitter<MatchingLearningState> emit) {
    emit(
      MatchingLearningState.loaded(
        state.data.copyWith(
          currentPageIndex: state.data.currentPageIndex + 1,
        ),
      ),
    );
  }

  void _onUpdateLearningStatistic(UpdateLearningStatistic event,
      Emitter<MatchingLearningState> emit) async {
    final resp = await _updateLearningStatisticsUseCase(
      UpdateLearningStatisticsParams(
        topicId: state.data.topic!.id!,
        learnedVocabularyIds:
            state.data.vocabularies.map((e) => e.id!).toList(),
        notLearnedVocabularyIds: const [],
        secondsSpent: state.data.seconds,
      ),
    );

    resp.fold(
      (failure) {
        emit(
          MatchingLearningState.error(
            state.data.copyWith(
              error: failure.message,
            ),
          ),
        );
      },
      (data) {
        emit(
          MatchingLearningUpdatedLearningStatistic(
            state.data,
          ),
        );
      },
    );
  }
}
