part of 'add_topic_bloc.dart';

@freezed
abstract class AddTopicEvent with _$AddTopicEvent {
  const factory AddTopicEvent.changeFlashcardIndex(int index) =
      ChangeFlashcardIndex;
  const factory AddTopicEvent.addFlashcard() = AddFlashcard;
  const factory AddTopicEvent.removeFlashcard(int index) = RemoveFlashcard;
  const factory AddTopicEvent.pickImage(int index, File image) = PickImage;
  const factory AddTopicEvent.removeImage(int index) = RemoveImage;
  const factory AddTopicEvent.changeTermLanguage(String language) =
      ChangeTermLanguage;
  const factory AddTopicEvent.changeDefinitionLanguage(String language) =
      ChangeDefinitionLanguage;
  const factory AddTopicEvent.changeTopicPublic(bool isPublic) =
      ChangeTopicPublic;
  const factory AddTopicEvent.addTopic(
      String topicName, String topicDescription) = AddTopic;
  const factory AddTopicEvent.loadedTopic(Topic topic) = LoadedTopic;
  const factory AddTopicEvent.deleteTopic() = DeleteTopic;
  const factory AddTopicEvent.updateTopic({
    required String topicName,
    required String topicDescription,
  }) = UpdateTopicEvent;
  const factory AddTopicEvent.importCsvFile() = ImportCsvFileEvent;
}
