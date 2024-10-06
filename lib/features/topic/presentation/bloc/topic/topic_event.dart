part of 'topic_bloc.dart';

@freezed
abstract class TopicEvent with _$TopicEvent {
  const factory TopicEvent.getTopics() = GetTopics;
  const factory TopicEvent.addPendingBloc(AddTopicBloc addTopicBloc) =
      AddPendingBloc;
  const factory TopicEvent.removePendingBloc(AddTopicBloc addTopicBloc) =
      RemovePendingBloc;
}
