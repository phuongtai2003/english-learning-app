import 'dart:io';

import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/features/topic/data/model/recently_learned_response.dart';
import 'package:final_flashcard/features/topic/data/model/topic_details_response.dart';
import 'package:final_flashcard/features/topic/domain/entities/topic.dart';
import 'package:final_flashcard/features/topic/domain/entities/vocabulary.dart';
import 'package:final_flashcard/features/topic/domain/use_case/get_user_topics.dart';

abstract class TopicRepository {
  ResultFuture<bool> addTopic({
    required String topicName,
    required String topicDescription,
    required bool isPublic,
    required List<File> images,
    required String termLanguage,
    required String definitionLanguage,
    required List<String> terms,
    required List<String> definitions,
    required List<int> indexes,
  });

  ResultFuture<GetUserTopicsUseCaseResult> getUserTopics();

  ResultFuture<List<Topic>> getAvailableTopics(int folderId);

  ResultFuture<List<Topic>> addTopicsToFolder(List<int> topicIds, int folderId);

  ResultFuture<bool> deleteTopic(int topicId);

  ResultFuture<Topic> updateTopic({
    required int topicId,
    required String topicName,
    required String topicDescription,
    required String definitionLanguage,
    required String termLanguage,
    required List<String> oldVocabulariesIds,
    required List<String> oldVocabulariesTerms,
    required List<String> oldVocabulariesDefinitions,
    required List<String> newVocabulariesTerms,
    required List<String> newVocabulariesDefinitions,
    required List<String> deletedVocabulariesIds,
    required List<File> imagesList,
    required List<String> hasImages,
  });

  ResultFuture<TopicDetailsResponse> getTopicDetails(int topicId, int userId);

  ResultFuture<bool> downloadTopicToLocal(Topic topic, int userId);

  ResultFuture<Vocabulary> favoriteVocabulary(int vocabId);

  ResultFuture<RecentlyLearnedResponse?> getRecentlyLearned();
}
