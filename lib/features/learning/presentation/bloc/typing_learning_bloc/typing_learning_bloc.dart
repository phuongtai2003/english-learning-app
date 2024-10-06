import 'package:final_flashcard/features/learning/domain/entities/quiz.dart';
import 'package:final_flashcard/features/learning/domain/use_cases/update_learning_statistics.dart';
import 'package:final_flashcard/features/topic/domain/entities/topic.dart';
import 'package:final_flashcard/features/topic/domain/entities/vocabulary.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'typing_learning_event.dart';
part 'typing_learning_state.dart';
part 'typing_learning_bloc.freezed.dart';

class TypingLearningBloc
    extends Bloc<TypingLearningEvent, TypingLearningState> {
  final UpdateLearningStatisticsUseCase _updateLearningStatisticsUseCase;
  TypingLearningBloc(
    this._updateLearningStatisticsUseCase,
  ) : super(const TypingLearningState.initial(TypingLearningStateData())) {
    on<InitTypingLearning>(_initTypingLearning);
    on<ChangeTypingAnswerWith>(_changeTypingAnswerWith);
    on<ChangeTypingPromptWith>(_changeTypingPromptWith);
    on<ChangeTypingInstantFeedback>(_changeTypingInstantFeedback);
    on<ChangeTypingShuffle>(_changeTypingShuffle);
    on<TypingClearError>(_clearError);
    on<TypingStartQuiz>(_startQuiz);
    on<AnswerTypingQuiz>(_answerTypingQuiz);
    on<TypingNextQuiz>(_nextQuiz);
    on<UpdateTypingLearningStatistics>(_updateTypingLearningStatistics);
  }

  void _initTypingLearning(
      InitTypingLearning event, Emitter<TypingLearningState> emit) async {
    final selectedVocabularies = [...event.selectedVocabularies];
    final List<Quiz> quizzes = [];
    for (final correctAnswer in selectedVocabularies) {
      final Quiz quiz = Quiz(
        answerText: '',
        findDefinition: false,
        isPromptTerm: false,
        vocabulary: correctAnswer,
        options: const [],
        isCorrect: false,
        answer: null,
      );
      quizzes.add(quiz);
    }
    emit(
      TypingLearningState.settings(
        state.data.copyWith(
          topic: event.topic,
          currentQuizIndex: 0,
          quizzes: quizzes,
          vocabularies: selectedVocabularies,
        ),
      ),
    );
  }

  void _changeTypingAnswerWith(
      ChangeTypingAnswerWith event, Emitter<TypingLearningState> emit) {
    emit(
      TypingLearningState.settings(
        state.data.copyWith(
          answerTerm: event.answerTerm,
          answerDefinition: event.answerDefinition,
        ),
      ),
    );
  }

  void _changeTypingPromptWith(
      ChangeTypingPromptWith event, Emitter<TypingLearningState> emit) {
    emit(
      TypingLearningState.settings(
        state.data.copyWith(
          promptTerm: event.promptTerm,
          promptDefinition: event.promptDefinition,
        ),
      ),
    );
  }

  void _changeTypingInstantFeedback(
      ChangeTypingInstantFeedback event, Emitter<TypingLearningState> emit) {
    emit(
      TypingLearningState.settings(
        state.data.copyWith(
          instantFeedback: event.instantFeedback,
        ),
      ),
    );
  }

  void _changeTypingShuffle(
      ChangeTypingShuffle event, Emitter<TypingLearningState> emit) {
    emit(
      TypingLearningState.settings(
        state.data.copyWith(
          shuffle: event.shuffle,
        ),
      ),
    );
  }

  void _clearError(TypingClearError event, Emitter<TypingLearningState> emit) {
    emit(
      TypingLearningState.settings(
        state.data.copyWith(
          error: '',
        ),
      ),
    );
  }

  void _startQuiz(TypingStartQuiz event, Emitter<TypingLearningState> emit) {
    if (event.questionCount <= 0 ||
        event.questionCount > state.data.vocabularies.length) {
      emit(
        TypingLearningState.error(
          state.data.copyWith(
            error: 'invalid_question_count',
          ),
        ),
      );
    } else {
      final isShuffle = state.data.shuffle;
      final List<Quiz> quizzes = [...state.data.quizzes];
      if (isShuffle) {
        quizzes.shuffle();
      }
      final quizzesList = quizzes.sublist(0, event.questionCount);
      emit(
        TypingLearningState.loaded(
          state.data.copyWith(
            currentQuizIndex: 0,
            quizzes: quizzesList,
          ),
        ),
      );
    }
  }

  void _answerTypingQuiz(
      AnswerTypingQuiz event, Emitter<TypingLearningState> emit) {
    final currentQuizIndex = state.data.currentQuizIndex;
    final quizzes = [...state.data.quizzes];
    final currentQuiz = quizzes[currentQuizIndex];
    final isCorrect = currentQuiz.vocabulary?.term == event.answer;
    final updatedQuiz = currentQuiz.copyWith(
      answerText: event.answer,
      isCorrect: isCorrect,
      findDefinition: event.findDefinition,
      isPromptTerm: event.isPromptTerm,
    );
    quizzes[currentQuizIndex] = updatedQuiz;
    if (state.data.instantFeedback) {
      if (isCorrect) {
        emit(
          TypingLearningState.correctAnswer(
            state.data.copyWith(
              quizzes: quizzes,
            ),
          ),
        );
      } else {
        emit(
          TypingLearningState.wrongAnswer(
            state.data.copyWith(
              quizzes: quizzes,
            ),
          ),
        );
      }
    } else {
      if (state.data.currentQuizIndex < state.data.quizzes.length - 1) {
        emit(
          TypingLearningState.loaded(
            state.data.copyWith(
              quizzes: quizzes,
              currentQuizIndex: state.data.currentQuizIndex + 1,
            ),
          ),
        );
      } else {
        emit(
          TypingLearningState.finished(
            state.data.copyWith(
              quizzes: quizzes,
            ),
          ),
        );
      }
    }
  }

  void _nextQuiz(TypingNextQuiz event, Emitter<TypingLearningState> emit) {
    if (state.data.currentQuizIndex < state.data.quizzes.length - 1) {
      emit(
        TypingLearningState.loaded(
          state.data.copyWith(
            currentQuizIndex: state.data.currentQuizIndex + 1,
          ),
        ),
      );
    } else {
      emit(
        TypingLearningState.finished(
          state.data,
        ),
      );
    }
  }

  void _updateTypingLearningStatistics(UpdateTypingLearningStatistics event,
      Emitter<TypingLearningState> emit) async {
    final correctQuizzes =
        state.data.quizzes.where((quiz) => quiz.isCorrect ?? false).toList();
    final notCorrectQuizzes =
        state.data.quizzes.where((quiz) => !(quiz.isCorrect ?? false)).toList();
    final resp = await _updateLearningStatisticsUseCase(
      UpdateLearningStatisticsParams(
        learnedVocabularyIds:
            correctQuizzes.map((quiz) => quiz.vocabulary!.id!).toList(),
        notLearnedVocabularyIds:
            notCorrectQuizzes.map((quiz) => quiz.vocabulary!.id!).toList(),
        topicId: state.data.topic!.id!,
        secondsSpent: event.seconds,
      ),
    );

    resp.fold(
      (failure) {
        emit(
          TypingLearningState.error(
            state.data.copyWith(
              error: failure.message,
            ),
          ),
        );
      },
      (data) {
        emit(
          TypingLearningUpdatedLearningStatistics(
            state.data.copyWith(
              error: '',
            ),
          ),
        );
      },
    );
  }
}
