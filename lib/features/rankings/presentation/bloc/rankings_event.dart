part of 'rankings_bloc.dart';

@freezed
abstract class RankingsEvent with _$RankingsEvent {
  const factory RankingsEvent.getRankings({
    required Topic topic,
  }) = GetRankings;
}
