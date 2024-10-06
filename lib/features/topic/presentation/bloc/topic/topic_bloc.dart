import 'package:final_flashcard/features/learning/data/models/topic_learning_statistics.dart';
import 'package:final_flashcard/features/learning/domain/entities/topic_learning_statistics.dart';
import 'package:final_flashcard/features/learning/domain/entities/vocabulary_statistics.dart';
import 'package:final_flashcard/features/topic/domain/entities/topic.dart';
import 'package:final_flashcard/features/topic/domain/use_case/get_recently_learned.dart';
import 'package:final_flashcard/features/topic/domain/use_case/get_user_topics.dart';
import 'package:final_flashcard/features/topic/presentation/bloc/add_topic_bloc/add_topic_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'topic_event.dart';
part 'topic_state.dart';
part 'topic_bloc.freezed.dart';

class TopicBloc extends Bloc<TopicEvent, TopicState> {
  final GetUserTopicUseCase _getUserTopicUseCase;
  final GetRecentlyLearnedUseCase _getRecentlyLearnedUseCase;
  TopicBloc(
    this._getUserTopicUseCase,
    this._getRecentlyLearnedUseCase,
  ) : super(
          const TopicState.initial(
            TopicStateData(),
          ),
        ) {
    on<GetTopics>(_getTopics);
    on<AddPendingBloc>(_addPendingBloc);
    on<RemovePendingBloc>(_removePendingBloc);
  }

  void _addPendingBloc(AddPendingBloc event, Emitter<TopicState> emit) {
    emit(
      TopicState.addPendingBloc(
        state.data.copyWith(
          addTopicBlocs: [
            event.addTopicBloc,
            ...state.data.addTopicBlocs,
          ],
        ),
      ),
    );
  }

  void _removePendingBloc(RemovePendingBloc event, Emitter<TopicState> emit) {
    emit(
      TopicState.removePendingBloc(
        state.data.copyWith(
          addTopicBlocs: state.data.addTopicBlocs
              .where((bloc) => bloc != event.addTopicBloc)
              .toList(),
        ),
      ),
    );
  }

  void _getTopics(GetTopics event, Emitter<TopicState> emit) async {
    emit(
      TopicState.loading(
        state.data,
      ),
    );
    final result = await _getUserTopicUseCase();
    result.fold(
      (error) {
        print("Tai Nguyen ${error.message}");
        emit(
          TopicState.error(
            state.data.copyWith(
              error: error.message,
            ),
          ),
        );
      },
      (topics) {
        emit(
          TopicState.loaded(
            state.data.copyWith(
              topics: topics.topics,
              topicLearningStatistics: topics.topicLearningStatistics,
              vocabularyStatistics: topics.vocabularyStatistics,
            ),
          ),
        );
      },
    );
    final recentlyLearnedResult = await _getRecentlyLearnedUseCase();

    recentlyLearnedResult.fold(
      (error) {
        emit(
          TopicState.error(
            state.data.copyWith(
              error: error.message,
            ),
          ),
        );
      },
      (recentlyLearned) {
        if (recentlyLearned == null) {
          return;
        }
        emit(
          TopicState.loaded(
            state.data.copyWith(
              recentTopicLearningStatisticsModel:
                  recentlyLearned.topicLearningStatistics,
              recentVocabularyStatistics:
                  recentlyLearned.vocabularyStatistics ?? [],
            ),
          ),
        );
      },
    );
  }
}
