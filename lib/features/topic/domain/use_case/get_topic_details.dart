import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/core/use_case/use_case.dart';
import 'package:final_flashcard/features/topic/data/model/topic_details_response.dart';
import 'package:final_flashcard/features/topic/domain/repository/topic_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetTopicDetailsUseCase implements UseCaseWithParams<TopicDetailsResponse, DataMap> {
  final TopicRepository _topicRepository;

  GetTopicDetailsUseCase(this._topicRepository);
  @override
  ResultFuture<TopicDetailsResponse> call(DataMap params) async {
    return await _topicRepository.getTopicDetails(
      params['topicId'],
      params['userId'],
    );
  }
}
