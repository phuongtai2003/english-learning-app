import 'dart:math';

import 'package:final_flashcard/features/learning/domain/entities/quiz.dart';
import 'package:final_flashcard/features/learning/domain/use_cases/update_learning_statistics.dart';
import 'package:final_flashcard/features/topic/domain/entities/topic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../topic/domain/entities/vocabulary.dart';

part 'quiz_learning_event.dart';
part 'quiz_learning_state.dart';
part 'quiz_learning_bloc.freezed.dart';

class QuizLearningBloc extends Bloc<QuizLearningEvent, QuizLearningState> {
  final UpdateLearningStatisticsUseCase _updateLearningStatisticsUseCase;

  QuizLearningBloc(
    this._updateLearningStatisticsUseCase,
  ) : super(
          const QuizLearningState.initial(
            QuizLearningStateData(),
          ),
        ) {
    on<InitQuizLearning>(_initQuizLearning);
    on<ChangeInstantFeedback>(_changeInstantFeedback);
    on<ChangeAnswerWith>(_changeAnswerWith);
    on<ChangePromptWith>(_changePromptWith);
    on<StartQuizEvent>(_startQuiz);
    on<ClearError>(_clearError);
    on<AnswerQuiz>(_answerQuiz);
    on<NextQuizEvent>(_nextQuiz);
    on<UpdateLearningStatistic>(_updateLearningStatistic);
  }

  void _initQuizLearning(
      InitQuizLearning event, Emitter<QuizLearningState> emit) {
    final shuffledVocabularies = [...event.selectedVocabularies]..shuffle();
    final originalVocabularies = [...(event.topic.vocabularies ?? [])];
    final random = Random();
    final List<Quiz> quizzes = [];
    final thresholdWrongAnswers =
        originalVocabularies.length > 3 ? 3 : originalVocabularies.length - 1;
    for (final correctAnswer in shuffledVocabularies) {
      final List<Vocabulary> wrongAnswers = [];
      while (wrongAnswers.length != thresholdWrongAnswers) {
        final vocab =
            originalVocabularies[random.nextInt(originalVocabularies.length)];
        if (vocab.id != correctAnswer.id &&
            wrongAnswers
                .where((element) => element.id == vocab.id)
                .toList()
                .isEmpty) {
          wrongAnswers.add(vocab);
        }
      }

      final Quiz quiz = Quiz(
        answerText: null,
        findDefinition: false,
        isPromptTerm: false,
        vocabulary: correctAnswer,
        options: [correctAnswer, ...wrongAnswers]..shuffle(),
        isCorrect: false,
        answer: null,
      );
      quizzes.add(quiz);
    }
    emit(
      QuizLearningState.settings(
        state.data.copyWith(
          topic: event.topic,
          quizzes: quizzes,
          currentQuizIndex: 0,
          vocabularies: shuffledVocabularies,
        ),
      ),
    );
  }

  void _changeInstantFeedback(
      ChangeInstantFeedback event, Emitter<QuizLearningState> emit) {
    emit(
      QuizLearningState.settings(
        state.data.copyWith(
          instantFeedback: event.instantFeedback,
        ),
      ),
    );
  }

  void _changeAnswerWith(
      ChangeAnswerWith event, Emitter<QuizLearningState> emit) {
    emit(
      QuizLearningState.settings(
        state.data.copyWith(
          answerDefinition: event.answerDefinition,
          answerTerm: event.answerTerm,
        ),
      ),
    );
  }

  void _changePromptWith(
      ChangePromptWith event, Emitter<QuizLearningState> emit) {
    emit(
      QuizLearningState.settings(
        state.data.copyWith(
          promptDefinition: event.promptDefinition,
          promptTerm: event.promptTerm,
        ),
      ),
    );
  }

  void _startQuiz(StartQuizEvent event, Emitter<QuizLearningState> emit) {
    if (event.questionCount <= 0 ||
        event.questionCount > state.data.quizzes.length) {
      emit(
        QuizLearningState.error(
          state.data.copyWith(
            error: 'invalid_question_count',
          ),
        ),
      );
    } else {
      final List<Quiz> quizzes =
          state.data.quizzes.sublist(0, event.questionCount);
      emit(
        QuizLearningState.loaded(
          state.data.copyWith(
            currentQuizIndex: 0,
            quizzes: quizzes,
          ),
        ),
      );
    }
  }

  void _clearError(ClearError event, Emitter<QuizLearningState> emit) {
    emit(
      QuizLearningState.settings(
        state.data.copyWith(
          error: '',
        ),
      ),
    );
  }

  void _answerQuiz(AnswerQuiz event, Emitter<QuizLearningState> emit) {
    final currentQuiz = state.data.quizzes[state.data.currentQuizIndex];
    final isCorrect = currentQuiz.vocabulary?.id == event.answer.id;
    final updatedQuiz = currentQuiz.copyWith(
      isCorrect: isCorrect,
      findDefinition: event.findDefinition,
      isPromptTerm: event.isPromptTerm,
      answer: event.answer,
    );
    final updatedQuizzes = [
      ...state.data.quizzes,
    ];
    updatedQuizzes[state.data.currentQuizIndex] = updatedQuiz;
    if (state.data.instantFeedback) {
      if (isCorrect) {
        emit(
          QuizLearningState.correctAnswer(
            state.data.copyWith(
              quizzes: updatedQuizzes,
            ),
          ),
        );
      } else {
        emit(
          QuizLearningState.wrongAnswer(
            state.data.copyWith(
              quizzes: updatedQuizzes,
            ),
          ),
        );
      }
    } else {
      if (state.data.currentQuizIndex < state.data.quizzes.length - 1) {
        emit(
          QuizLearningState.loaded(
            state.data.copyWith(
              quizzes: updatedQuizzes,
              currentQuizIndex: state.data.currentQuizIndex + 1,
            ),
          ),
        );
      } else {
        emit(
          QuizLearningState.finished(
            state.data.copyWith(
              quizzes: updatedQuizzes,
            ),
          ),
        );
      }
    }
  }

  void _nextQuiz(NextQuizEvent event, Emitter<QuizLearningState> emit) {
    if (state.data.currentQuizIndex < state.data.quizzes.length - 1) {
      emit(
        QuizLearningState.loaded(
          state.data.copyWith(
            currentQuizIndex: state.data.currentQuizIndex + 1,
          ),
        ),
      );
    } else {
      emit(
        QuizLearningState.finished(
          state.data,
        ),
      );
    }
  }

  void _updateLearningStatistic(
      UpdateLearningStatistic event, Emitter<QuizLearningState> emit) async {
    final correctQuizzes = state.data.quizzes
        .where((element) => element.isCorrect ?? false)
        .toList();
    final notCorrectQuizzes = state.data.quizzes
        .where((element) => !(element.isCorrect ?? false))
        .toList();
    final resp = await _updateLearningStatisticsUseCase(
      UpdateLearningStatisticsParams(
        learnedVocabularyIds:
            correctQuizzes.map((e) => e.vocabulary!.id!).toList(),
        notLearnedVocabularyIds:
            notCorrectQuizzes.map((e) => e.vocabulary!.id!).toList(),
        topicId: state.data.topic!.id!,
        secondsSpent: event.seconds,
      ),
    );

    resp.fold(
      (failure) {
        emit(
          QuizLearningState.error(
            state.data.copyWith(
              error: failure.message,
            ),
          ),
        );
      },
      (r) {
        emit(
          QuizLearningUpdateStatistic(
            state.data.copyWith(
              error: '',
            ),
          ),
        );
      },
    );
  }
}
