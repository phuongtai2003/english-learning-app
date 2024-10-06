part of 'folder_to_topic_bloc.dart';

@freezed
abstract class FolderToTopicEvent with _$FolderToTopicEvent {
  const factory FolderToTopicEvent.loadAvailableFolders({
    required Topic topic,
  }) = LoadAvailableFolders;
  const factory FolderToTopicEvent.triggerFolderSelection({
    required Folder folder,
  }) = TriggerFolderSelection;
  const factory FolderToTopicEvent.createFolder({
    required String title,
    required String description,
  }) = CreateFolder;
  const factory FolderToTopicEvent.addFoldersToTopic() = AddFoldersToTopicEvent;
}
