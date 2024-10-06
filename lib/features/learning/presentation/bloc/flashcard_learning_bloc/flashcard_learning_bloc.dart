import 'package:final_flashcard/features/learning/domain/use_cases/update_learning_statistics.dart';
import 'package:final_flashcard/features/topic/domain/entities/topic.dart';
import 'package:final_flashcard/features/topic/domain/entities/vocabulary.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'flashcard_learning_event.dart';
part 'flashcard_learning_state.dart';
part 'flashcard_learning_bloc.freezed.dart';

class FlashcardLearningBloc
    extends Bloc<FlashcardLearningEvent, FlashcardLearningState> {
  final UpdateLearningStatisticsUseCase _updateLearningStatisticsUseCase;
  FlashcardLearningBloc(
    this._updateLearningStatisticsUseCase,
  ) : super(
          const FlashcardLearningInitial(FlashcardLearningStateData()),
        ) {
    on<InitFlashcardLearning>(_initFlashcardLearning);
    on<NextFlashcard>(_nextFlashcard);
    on<PreviousFlashcard>(_previousFlashcard);
    on<FlashcardSpeakTerm>(_speakTerm);
    on<FlashcardSpeakDefinition>(_speakDefinition);
    on<ShuffleFlashcardsToggle>(_shuffleFlashcardsToggle);
    on<AutoSpeakToggle>(_autoSpeakToggle);
    on<AutoPlayToggle>(_autoPlayToggle);
    on<UpdateLearningStatistics>(_updateLearningStatistics);
  }

  void _initFlashcardLearning(
      InitFlashcardLearning event, Emitter<FlashcardLearningState> emit) async {
    final flipsCardControllers = List.generate(
      event.topic.vocabularies?.length ?? 0,
      (index) => FlipCardController(),
    );
    emit(
      FlashcardLearningState.loaded(
        state.data.copyWith(
          topic: event.topic,
          topicVocabularies: event.selectedVocabularies,
          topicVocabulariesShuffled: event.selectedVocabularies,
          totalFlashcard: event.selectedVocabularies.length,
          flipCardControllers: flipsCardControllers,
          currentFlashcardIndex: 0,
          learnedVocabularies: [],
          notLearnedVocabularies: [],
        ),
      ),
    );
  }

  void _nextFlashcard(
      NextFlashcard event, Emitter<FlashcardLearningState> emit) {
    final learnedFlashcardsList = [...state.data.learnedVocabularies];
    final notLearnedFlashcardsList = [...state.data.notLearnedVocabularies];
    if (event.isLearned) {
      learnedFlashcardsList.add(
        state.data.topicVocabulariesShuffled[state.data.currentFlashcardIndex],
      );
    } else {
      notLearnedFlashcardsList.add(
        state.data.topicVocabulariesShuffled[state.data.currentFlashcardIndex],
      );
    }
    if (state.data.currentFlashcardIndex < state.data.totalFlashcard - 1) {
      emit(
        FlashcardLearningState.loaded(
          state.data.copyWith(
            currentFlashcardIndex: state.data.currentFlashcardIndex + 1,
            learnedVocabularies: learnedFlashcardsList,
            notLearnedVocabularies: notLearnedFlashcardsList,
          ),
        ),
      );
    } else {
      emit(
        FlashcardLearningState.completed(
          state.data.copyWith(
            isCompleted: true,
            learnedVocabularies: learnedFlashcardsList,
            notLearnedVocabularies: notLearnedFlashcardsList,
            isAutoPlay: false,
            autoSpeak: false,
          ),
        ),
      );
    }
  }

  void _previousFlashcard(
      PreviousFlashcard event, Emitter<FlashcardLearningState> emit) {
    final previousIndex = state.data.currentFlashcardIndex - 1;
    final previousVocabulary =
        state.data.topicVocabulariesShuffled[previousIndex];
    final learnedFlashcardsList = [...state.data.learnedVocabularies];
    final notLearnedFlashcardsList = [...state.data.notLearnedVocabularies];
    if (learnedFlashcardsList.contains(previousVocabulary)) {
      learnedFlashcardsList.removeWhere(
        (vocab) => vocab.id == previousVocabulary.id,
      );
    } else {
      notLearnedFlashcardsList.removeWhere(
        (vocab) => vocab.id == previousVocabulary.id,
      );
    }
    emit(
      FlashcardLearningState.loaded(
        state.data.copyWith(
          currentFlashcardIndex: state.data.currentFlashcardIndex - 1,
          learnedVocabularies: learnedFlashcardsList,
          notLearnedVocabularies: notLearnedFlashcardsList,
        ),
      ),
    );
  }

  void _speakTerm(
      FlashcardSpeakTerm event, Emitter<FlashcardLearningState> emit) {
    emit(
      FlashcardLearningState.loaded(
        state.data.copyWith(
          speakingFlashcardIndex: event.index,
          isTermSpeaking: event.isSpeaking,
        ),
      ),
    );
  }

  void _speakDefinition(
      FlashcardSpeakDefinition event, Emitter<FlashcardLearningState> emit) {
    emit(
      FlashcardLearningState.loaded(
        state.data.copyWith(
          speakingFlashcardIndex: event.index,
          isDefinitionSpeaking: event.isSpeaking,
        ),
      ),
    );
  }

  void _shuffleFlashcardsToggle(
      ShuffleFlashcardsToggle event, Emitter<FlashcardLearningState> emit) {
    if (state.data.shuffleFlashcards == false) {
      final originalVocabularies = [...state.data.topicVocabularies];
      final learnedVocabularies = [...state.data.learnedVocabularies];
      final notLearnedVocabularies = [...state.data.notLearnedVocabularies];
      final passedVocabularies = [
        ...learnedVocabularies,
        ...notLearnedVocabularies
      ];
      originalVocabularies.removeWhere(
        (element) => passedVocabularies.contains(element),
      );
      final shuffledVocabularies = [
        ...(originalVocabularies..shuffle()),
      ];
      emit(
        FlashcardLearningState.loaded(
          state.data.copyWith(
            topicVocabulariesShuffled: shuffledVocabularies,
            shuffleFlashcards: !state.data.shuffleFlashcards,
          ),
        ),
      );
    } else {
      final originalVocabularies = [...state.data.topicVocabularies];
      emit(
        FlashcardLearningState.loaded(
          state.data.copyWith(
            topicVocabulariesShuffled: originalVocabularies,
            shuffleFlashcards: !state.data.shuffleFlashcards,
          ),
        ),
      );
    }
  }

  void _autoSpeakToggle(
      AutoSpeakToggle event, Emitter<FlashcardLearningState> emit) {
    emit(
      FlashcardLearningState.loaded(
        state.data.copyWith(
          autoSpeak: !state.data.autoSpeak,
          isAutoPlay: false,
        ),
      ),
    );
  }

  void _autoPlayToggle(
      AutoPlayToggle event, Emitter<FlashcardLearningState> emit) {
    emit(
      FlashcardLearningState.loaded(
        state.data.copyWith(
          isAutoPlay: !state.data.isAutoPlay,
          autoSpeak: false,
        ),
      ),
    );
  }

  void _updateLearningStatistics(UpdateLearningStatistics event,
      Emitter<FlashcardLearningState> emit) async {
    emit(FlashcardLearningState.loading(state.data));
    final response = await _updateLearningStatisticsUseCase(
      UpdateLearningStatisticsParams(
        learnedVocabularyIds:
            state.data.learnedVocabularies.map((vocab) => vocab.id!).toList(),
        notLearnedVocabularyIds: state.data.notLearnedVocabularies
            .map((vocab) => vocab.id!)
            .toList(),
        topicId: state.data.topic!.id!,
        secondsSpent: event.timeSpent,
      ),
    );
    response.fold(
      (failure) {
        emit(
          FlashcardLearningState.error(
            state.data.copyWith(
              error: failure.message,
            ),
          ),
        );
      },
      (data) {
        emit(
          FlashcardLearningUpdateCompleted(
            state.data,
          ),
        );
      },
    );
  }
}
