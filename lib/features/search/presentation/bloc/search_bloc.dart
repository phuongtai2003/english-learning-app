import 'package:final_flashcard/features/search/domain/use_case/fetch_search_topics.dart';
import 'package:final_flashcard/features/topic/domain/entities/topic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_event.dart';
part 'search_state.dart';

part 'search_bloc.freezed.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final FetchSearchTopicsUseCase _fetchSearchTopicsUseCase;
  SearchBloc(
    this._fetchSearchTopicsUseCase,
  ) : super(const SearchInitial(SearchStateData())) {
    on<FetchSearchesTopics>(_fetchSearchesTopics);
    on<ToggleFocusEvent>(_toggleFocus);
    on<QueryTopicsEvent>(_queryTopics);
  }

  void _fetchSearchesTopics(
    FetchSearchesTopics event,
    Emitter<SearchState> emit,
  ) async {
    emit(
      SearchLoading(
        state.data,
      ),
    );
    final resp = await _fetchSearchTopicsUseCase();

    resp.fold(
      (failure) {
        emit(
          SearchError(
            state.data.copyWith(
              error: failure.message,
            ),
          ),
        );
      },
      (topics) {
        emit(
          SearchLoaded(
            state.data.copyWith(
              originalTopics: topics,
              filteredTopics: topics,
            ),
          ),
        );
      },
    );
  }

  void _toggleFocus(
    ToggleFocusEvent event,
    Emitter<SearchState> emit,
  ) {
    emit(
      SearchLoaded(
        state.data.copyWith(
          isFocus: event.isFocus,
          filteredTopics: !event.isFocus
              ? state.data.originalTopics
              : state.data.filteredTopics,
        ),
      ),
    );
  }

  void _queryTopics(QueryTopicsEvent event, Emitter<SearchState> emit) {
    final query = event.query;
    final filteredTopics = state.data.originalTopics.where((topic) {
      return topic.title?.toLowerCase().contains(query.toLowerCase()) ?? false;
    }).toList();

    emit(
      SearchLoaded(
        state.data.copyWith(
          filteredTopics: filteredTopics,
        ),
      ),
    );
  }
}
