part of 'search_bloc.dart';

@freezed
abstract class SearchEvent with _$SearchEvent {
  const factory SearchEvent.fetchSearchesTopics() = FetchSearchesTopics;
  const factory SearchEvent.toggleFocus({
    required bool isFocus,
  }) = ToggleFocusEvent;
  const factory SearchEvent.search({
    required String query,
  }) = QueryTopicsEvent;
}
