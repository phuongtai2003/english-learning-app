import 'package:final_flashcard/features/rankings/domain/entities/rankings.dart';
import 'package:final_flashcard/features/rankings/domain/use_case/get_rankings.dart';
import 'package:final_flashcard/features/topic/domain/entities/topic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'rankings_event.dart';
part 'rankings_state.dart';

part 'rankings_bloc.freezed.dart';

class RankingsBloc extends Bloc<RankingsEvent, RankingsState> {
  final GetRankingsUseCase _getRankingsUseCase;
  RankingsBloc(
    this._getRankingsUseCase,
  ) : super(const RankingsState.initial(RankingsStateData())) {
    on<GetRankings>(_getRankings);
  }

  void _getRankings(GetRankings event, Emitter<RankingsState> emit) async {
    emit(
      RankingsState.loading(
        state.data.copyWith(
          topic: event.topic,
        ),
      ),
    );
    final resp = await _getRankingsUseCase(event.topic.id!);

    resp.fold(
      (failure) {
        emit(
          RankingsError(
            state.data.copyWith(
              error: failure.message,
            ),
          ),
        );
      },
      (rankings) => emit(
        RankingsLoaded(
          state.data.copyWith(
            rankings: rankings,
          ),
        ),
      ),
    );
  }
}
