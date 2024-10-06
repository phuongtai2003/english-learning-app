import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/features/rankings/domain/entities/rankings.dart';

abstract class RankingsRepository {
  ResultFuture<List<Rankings>> getRankings(int topicId);
}
