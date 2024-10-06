import 'package:dio/dio.dart';
import 'package:final_flashcard/configs/common/global_constants.dart';
import 'package:final_flashcard/features/rankings/data/model/rankings.dart';
import 'package:retrofit/http.dart';
part 'rankings_remote_data_source.g.dart';

@RestApi(baseUrl: GlobalConstants.baseUrl)
abstract class RankingsRemoteDataSource {
  factory RankingsRemoteDataSource(
    Dio dio,
  ) = _RankingsRemoteDataSource;

  @GET('/learning/rankings/{topicId}')
  Future<List<RankingsModel>> getRankings(@Path('topicId') int topicId);
}
