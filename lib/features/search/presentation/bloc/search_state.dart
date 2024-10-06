part of 'search_bloc.dart';

@freezed
abstract class SearchStateData with _$SearchStateData {
  const factory SearchStateData({
    @Default('') String error,
    @Default(false) bool isFocus,
    @Default([]) List<Topic> originalTopics,
    @Default([]) List<Topic> filteredTopics,
  }) = _SearchStateData;
}

@freezed
abstract class SearchState with _$SearchState {
  const factory SearchState.initial(SearchStateData data) = SearchInitial;
  const factory SearchState.loading(SearchStateData data) = SearchLoading;
  const factory SearchState.loaded(SearchStateData data) = SearchLoaded;
  const factory SearchState.error(SearchStateData data) = SearchError;
}
