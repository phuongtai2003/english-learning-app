import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/core/use_case/use_case.dart';
import 'package:final_flashcard/features/rankings/domain/entities/rankings.dart';
import 'package:final_flashcard/features/rankings/domain/repository/rankings_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetRankingsUseCase implements UseCaseWithParams<List<Rankings>, int> {
  final RankingsRepository _rankingsRepository;

  GetRankingsUseCase(this._rankingsRepository);

  @override
  ResultFuture<List<Rankings>> call(int params) async {
    return await _rankingsRepository.getRankings(params);
  }
}
