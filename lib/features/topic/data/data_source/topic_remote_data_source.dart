import 'dart:io';

import 'package:dio/dio.dart';
import 'package:final_flashcard/configs/common/global_constants.dart';
import 'package:final_flashcard/features/topic/data/model/add_topics_to_folder_request.dart';
import 'package:final_flashcard/features/topic/data/model/get_topics_response.dart';
import 'package:final_flashcard/features/topic/data/model/recently_learned_response.dart';
import 'package:final_flashcard/features/topic/data/model/topic.dart';
import 'package:final_flashcard/features/topic/data/model/topic_details_response.dart';
import 'package:final_flashcard/features/topic/data/model/vocabulary.dart';
import 'package:retrofit/http.dart';

part 'topic_remote_data_source.g.dart';

@RestApi(baseUrl: GlobalConstants.baseUrl)
abstract class TopicRemoteDataSource {
  factory TopicRemoteDataSource(Dio dio) = _TopicRemoteDataSource;

  @POST("/topics/add")
  @MultiPart()
  Future<bool> addTopic({
    @Part(name: "topicName") required String topicName,
    @Part(name: "topicDescription") required String topicDescription,
    @Part(name: "isPublic") required bool isPublic,
    @Part(name: "images") required List<File> images,
    @Part(name: "termLanguage") required String termLanguage,
    @Part(name: "definitionLanguage") required String definitionLanguage,
    @Part(name: "terms") required List<String> terms,
    @Part(name: "definitions") required List<String> definitions,
    @Part(name: "indexes") required List<String> indexes,
  });

  @GET('/learning/recently-learned')
  Future<RecentlyLearnedResponse?> getRecentlyLearned();

  @GET("/topics")
  Future<GetTopicsResponse> getUserTopics();

  @GET('/topics/{folderId}/available')
  Future<List<TopicModel>> getAvailableTopics({
    @Path("folderId") required int folderId,
  });

  @POST('/topics/{folderId}/add-to-folder')
  Future<List<TopicModel>> addTopicsToFolder({
    @Path("folderId") required int folderId,
    @Body() required AddTopicsToFolderRequest request,
  });

  @DELETE('/topics/{topicId}')
  Future<bool> deleteTopic({
    @Path("topicId") required int topicId,
  });

  @PUT("/topics/{topicId}")
  @MultiPart()
  Future<TopicModel> updateTopic({
    @Path("topicId") required int topicId,
    @Part(name: "topicName") required String topicName,
    @Part(name: "topicDescription") required String topicDescription,
    @Part(name: "definitionLanguage") required String definitionLanguage,
    @Part(name: "termLanguage") required String termLanguage,
    @Part(name: "oldVocabulariesIds") required List<String> oldVocabulariesIds,
    @Part(name: "oldVocabulariesTerms")
    required List<String> oldVocabulariesTerms,
    @Part(name: "oldVocabulariesDefinitions")
    required List<String> oldVocabulariesDefinitions,
    @Part(name: "newVocabulariesTerms")
    required List<String> newVocabulariesTerms,
    @Part(name: "newVocabulariesDefinitions")
    required List<String> newVocabulariesDefinitions,
    @Part(name: "deletedVocabulariesIds")
    required List<String> deletedVocabulariesIds,
    @Part(name: "hasImages") required List<String> hasImages,
    @Part(name: "images") required List<File> imagesList,
  });

  @GET('/topics/{topicId}')
  Future<TopicDetailsResponse> getTopicDetails({
    @Path("topicId") required int topicId,
  });

  @POST('topics/{vocabId}/favorite')
  Future<VocabularyModel> favoriteVocabulary({
    @Path("vocabId") required int vocabId,
  });
}
