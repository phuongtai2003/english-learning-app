import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/core/errors/failure.dart';
import 'package:final_flashcard/features/search/data/data_source/search_remote_data_source.dart';
import 'package:final_flashcard/features/search/domain/repository/search_repository.dart';
import 'package:final_flashcard/features/topic/data/model/topic.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: SearchRepostory)
class SearchRepositoryImpl implements SearchRepostory {
  final SearchRemoteDataSource _searchRemoteDataSource;

  SearchRepositoryImpl(this._searchRemoteDataSource);
  @override
  ResultFuture<List<TopicModel>> fetchSearchTopics() async {
    try {
      final response = await _searchRemoteDataSource.fetchSearchTopics();
      return Right(response);
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
