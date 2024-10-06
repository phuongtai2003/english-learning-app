part of 'topic_details_bloc.dart';

@freezed
abstract class TopicDetailsEvent with _$TopicDetailsEvent {
  const factory TopicDetailsEvent.getTopicDetails({
    required int topicId,
    required int userId,
  }) = GetTopicDetails;
  const factory TopicDetailsEvent.toggleSpeakingStatus({
    required int vocabIndex,
    required bool isTermSpeaking,
    required bool isDefinitionSpeaking,
  }) = ToggleSpeakingStatus;
  const factory TopicDetailsEvent.toggleLearnButtonBottom({
    required bool showLearnButtonBottom,
  }) = ToggleLearnButtonBottom;
  const factory TopicDetailsEvent.downloadTopicToLocal({
    required Topic topic,
    required int userId,
  }) = DownloadTopicToLocal;
  const factory TopicDetailsEvent.favoriteVocabulary({
    required int vocabId,
  }) = FavoriteVocabulary;
  const factory TopicDetailsEvent.toggleStudyAll({required bool studyAll}) =
      ToggleStudyAll;
  const factory TopicDetailsEvent.deleteTopic() = DeleteTopic;
  const factory TopicDetailsEvent.addPendingTopicBloc({
    required AddTopicBloc addTopicBloc,
  }) = AddPendingTopicBloc;
  const factory TopicDetailsEvent.deletePendingTopicBloc() =
      DeletePendingTopicBloc;
  const factory TopicDetailsEvent.exportToCsv() = ExportToCsv;
}
