import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/core/errors/failure.dart';
import 'package:final_flashcard/features/rankings/data/data_source/rankings_remote_data_source.dart';
import 'package:final_flashcard/features/rankings/data/model/rankings.dart';
import 'package:final_flashcard/features/rankings/domain/repository/rankings_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: RankingsRepository)
class RankingsRepositoryImpl implements RankingsRepository {
  final RankingsRemoteDataSource _rankingsRemoteDataSource;

  RankingsRepositoryImpl(this._rankingsRemoteDataSource);
  @override
  ResultFuture<List<RankingsModel>> getRankings(int topicId) async {
    try {
      final rankings = await _rankingsRemoteDataSource.getRankings(topicId);
      return Right(rankings);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.statusMessage ?? 'something_went_wrong',
          statusCode: e.response?.statusCode ?? 500,
        ),
      );
    } catch (e) {
      return Left(
        ApiFailure(
          message: e.toString(),
          statusCode: 500,
        ),
      );
    }
  }
}
