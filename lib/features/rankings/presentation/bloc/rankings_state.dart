part of 'rankings_bloc.dart';

@freezed
abstract class RankingsStateData with _$RankingsStateData {
  const factory RankingsStateData({
    Topic? topic,
    @Default('') String error,
    @Default([]) List<Rankings> rankings,
  }) = _RankingsStateData;
}

@freezed
abstract class RankingsState with _$RankingsState {
  const factory RankingsState.initial(RankingsStateData data) = RankingsInitial;
  const factory RankingsState.loading(RankingsStateData data) = RankingsLoading;
  const factory RankingsState.loaded(RankingsStateData data) = RankingsLoaded;
  const factory RankingsState.error(RankingsStateData data) = RankingsError;
}
