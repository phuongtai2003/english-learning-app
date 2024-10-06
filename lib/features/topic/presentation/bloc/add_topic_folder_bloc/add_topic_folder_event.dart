part of 'add_topic_folder_bloc.dart';

@freezed
abstract class AddTopicFolderEvent with _$AddTopicFolderEvent {
  const factory AddTopicFolderEvent.getAvailableTopics(Folder folder) = GetAvailableTopics;
  const factory AddTopicFolderEvent.triggerSelectTopic(Topic topic) = TriggerSelectTopic;
  const factory AddTopicFolderEvent.addTopicsToFolder() = AddTopicsToFolder;
}
