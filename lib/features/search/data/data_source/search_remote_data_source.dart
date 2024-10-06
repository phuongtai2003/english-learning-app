import 'package:dio/dio.dart';
import 'package:final_flashcard/configs/common/global_constants.dart';
import 'package:final_flashcard/features/topic/data/model/topic.dart';
import 'package:retrofit/http.dart';

part 'search_remote_data_source.g.dart';

@RestApi(baseUrl: GlobalConstants.baseUrl)
abstract class SearchRemoteDataSource {
  factory SearchRemoteDataSource(Dio dio) = _SearchRemoteDataSource;

  @GET('/search/')
  Future<List<TopicModel>> fetchSearchTopics();
}
