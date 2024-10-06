import 'package:dio/dio.dart';
import 'package:final_flashcard/configs/common/global_constants.dart';
import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/features/learning/data/models/topic_learning_statistics.dart';
import 'package:retrofit/http.dart';

part 'topic_learning_remote_data_source.g.dart';

@RestApi(baseUrl: GlobalConstants.baseUrl)
abstract class TopicLearningRemoteDataSource {
  factory TopicLearningRemoteDataSource(Dio dio) =
      _TopicLearningRemoteDataSource;

  @POST('learning/learn-topic/{topicId}')
  Future<TopicLearningStatisticsModel> updateLearningStatistics({
    @Path('topicId') required int topicId,
    @Body() required DataMap body,
  });
}
