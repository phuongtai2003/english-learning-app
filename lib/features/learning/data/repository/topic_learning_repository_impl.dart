import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/core/errors/failure.dart';
import 'package:final_flashcard/features/learning/data/data_source/topic_learning_remote_data_source.dart';
import 'package:final_flashcard/features/learning/data/models/topic_learning_statistics.dart';
import 'package:final_flashcard/features/learning/domain/repository/topic_learning_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: TopicLearningRepository)
class TopicLearningRepositoryImpl implements TopicLearningRepository {
  final TopicLearningRemoteDataSource _topicLearningRemoteDataSource;

  TopicLearningRepositoryImpl(this._topicLearningRemoteDataSource);

  @override
  ResultFuture<TopicLearningStatisticsModel> updateLearningStatistics({
    required List<int> learnedVocabularyIds,
    required List<int> notLearnedVocabularyIds,
    required int topicId,
    required int secondsSpent,
  }) async {
    try {
      final map = <String, dynamic>{
        'learnedVocabularyIds': learnedVocabularyIds,
        'notLearnedVocabularyIds': notLearnedVocabularyIds,
        'timeSpent': secondsSpent,
      };
      final resp =
          await _topicLearningRemoteDataSource.updateLearningStatistics(
        topicId: topicId,
        body: map,
      );
      return Right(resp);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? e.message,
          statusCode: e.response?.statusCode ?? 500,
        ),
      );
    } catch (e) {
      return const Left(
        ApiFailure(
          message: 'something_went_wrong',
          statusCode: 500,
        ),
      );
    }
  }
}
