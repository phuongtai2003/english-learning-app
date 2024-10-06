import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/core/errors/failure.dart';
import 'package:final_flashcard/features/topic/data/data_source/topic_local_data_source.dart';
import 'package:final_flashcard/features/topic/data/data_source/topic_remote_data_source.dart';
import 'package:final_flashcard/features/topic/data/model/add_topics_to_folder_request.dart';
import 'package:final_flashcard/features/topic/data/model/recently_learned_response.dart';
import 'package:final_flashcard/features/topic/data/model/topic.dart';
import 'package:final_flashcard/features/topic/data/model/topic_details_response.dart';
import 'package:final_flashcard/features/topic/data/model/vocabulary.dart';
import 'package:final_flashcard/features/topic/domain/entities/topic.dart';
import 'package:final_flashcard/features/topic/domain/repository/topic_repository.dart';
import 'package:final_flashcard/features/topic/domain/use_case/get_user_topics.dart';

class TopicRepositoryImpl implements TopicRepository {
  final TopicRemoteDataSource _topicRemoteDataSource;
  final TopicLocalDataSource _topicLocalDataSource;

  TopicRepositoryImpl(
    this._topicRemoteDataSource,
    this._topicLocalDataSource,
  );

  @override
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
  }) async {
    try {
      final res = await _topicRemoteDataSource.addTopic(
        topicName: topicName,
        topicDescription: topicDescription,
        isPublic: isPublic,
        images: images,
        termLanguage: termLanguage,
        definitionLanguage: definitionLanguage,
        terms: terms,
        definitions: definitions,
        indexes: indexes.map((e) => e.toString()).toList(),
      );
      if (res == true) {
        return const Right(true);
      } else {
        return const Left(
          ApiFailure(
            statusCode: 500,
            message: 'something_went_wrong',
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          statusCode: e.response?.statusCode ?? 500,
          message: 'something_went_wrong',
        ),
      );
    } catch (e) {
      return Left(
        ApiFailure(
          statusCode: 500,
          message: e.toString(),
        ),
      );
    }
  }

  @override
  ResultFuture<GetUserTopicsUseCaseResult> getUserTopics() async {
    try {
      final res = await _topicRemoteDataSource.getUserTopics();
      return Right(
        GetUserTopicsUseCaseResult(
          res.topics,
          res.topicLearningStatistics,
          res.vocabularyStatistics,
        ),
      );
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          statusCode: e.response?.statusCode ?? 500,
          message: 'something_went_wrong',
        ),
      );
    } catch (e) {
      return Left(
        ApiFailure(
          statusCode: 500,
          message: e.toString(),
        ),
      );
    }
  }

  @override
  ResultFuture<List<TopicModel>> getAvailableTopics(int folderId) async {
    try {
      final res =
          await _topicRemoteDataSource.getAvailableTopics(folderId: folderId);
      return Right(res);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          statusCode: e.response?.statusCode ?? 500,
          message: 'something_went_wrong',
        ),
      );
    } catch (e) {
      return Left(
        ApiFailure(
          statusCode: 500,
          message: e.toString(),
        ),
      );
    }
  }

  @override
  ResultFuture<List<TopicModel>> addTopicsToFolder(
      List<int> topicIds, int folderId) async {
    try {
      final res = await _topicRemoteDataSource.addTopicsToFolder(
        folderId: folderId,
        request: AddTopicsToFolderRequest(topicIds: topicIds),
      );

      return Right(res);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          statusCode: e.response?.statusCode ?? 500,
          message: 'something_went_wrong',
        ),
      );
    } catch (e) {
      return Left(
        ApiFailure(
          statusCode: 500,
          message: e.toString(),
        ),
      );
    }
  }

  @override
  ResultFuture<bool> deleteTopic(int topicId) async {
    try {
      final res = await _topicRemoteDataSource.deleteTopic(topicId: topicId);
      return Right(res);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          statusCode: e.response?.statusCode ?? 500,
          message: 'something_went_wrong',
        ),
      );
    } catch (e) {
      return Left(
        ApiFailure(
          statusCode: 500,
          message: e.toString(),
        ),
      );
    }
  }

  @override
  ResultFuture<TopicModel> updateTopic({
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
  }) async {
    try {
      final res = await _topicRemoteDataSource.updateTopic(
        topicId: topicId,
        topicName: topicName,
        topicDescription: topicDescription,
        definitionLanguage: definitionLanguage,
        termLanguage: termLanguage,
        oldVocabulariesIds: oldVocabulariesIds,
        oldVocabulariesTerms: oldVocabulariesTerms,
        oldVocabulariesDefinitions: oldVocabulariesDefinitions,
        newVocabulariesTerms: newVocabulariesTerms,
        newVocabulariesDefinitions: newVocabulariesDefinitions,
        deletedVocabulariesIds: deletedVocabulariesIds,
        imagesList: imagesList,
        hasImages: hasImages,
      );
      return Right(res);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          statusCode: e.response?.statusCode ?? 500,
          message: 'something_went_wrong',
        ),
      );
    } catch (e) {
      return Left(
        ApiFailure(
          statusCode: 500,
          message: e.toString(),
        ),
      );
    }
  }

  @override
  ResultFuture<TopicDetailsResponse> getTopicDetails(
      int topicId, int userId) async {
    final isDownloaded = await _topicLocalDataSource.isTopicDownloaded(
      topicId,
      userId,
    );
    late TopicModel? cachedTopic;
    if (isDownloaded) {
      cachedTopic =
          await _topicLocalDataSource.getTopicFromStorage(topicId, userId);
      cachedTopic =
          TopicModel.fromEntity(cachedTopic!.copyWith(isDownloaded: true));
    }
    try {
      final res =
          await _topicRemoteDataSource.getTopicDetails(topicId: topicId);
      final topic = res.topic.copyWith(isDownloaded: isDownloaded);
      return Right(
        TopicDetailsResponse(
          favoriteVocabularies: res.favoriteVocabularies,
          topic: TopicModel.fromEntity(topic),
          vocabularyStatistics: res.vocabularyStatistics,
        ),
      );
    } on DioException catch (e) {
      if (cachedTopic != null) {
        return Right(
          TopicDetailsResponse(
            favoriteVocabularies: [],
            topic: cachedTopic,
            vocabularyStatistics: [],
          ),
        );
      }
      return Left(
        ApiFailure(
          statusCode: e.response?.statusCode ?? 500,
          message: 'something_went_wrong',
        ),
      );
    } catch (e) {
      if (cachedTopic != null) {
        return Right(
          TopicDetailsResponse(
            favoriteVocabularies: [],
            topic: cachedTopic,
            vocabularyStatistics: [],
          ),
        );
      }
      return Left(
        ApiFailure(
          statusCode: 500,
          message: e.toString(),
        ),
      );
    }
  }

  @override
  ResultFuture<bool> downloadTopicToLocal(Topic topic, int userId) async {
    try {
      await _topicLocalDataSource.saveTopicToStorage(
        topic: TopicModel.fromEntity(topic),
        userId: userId,
      );
      return const Right(true);
    } catch (e) {
      return Left(
        ApiFailure(
          statusCode: 500,
          message: e.toString(),
        ),
      );
    }
  }

  @override
  ResultFuture<VocabularyModel> favoriteVocabulary(int vocabId) async {
    try {
      final res =
          await _topicRemoteDataSource.favoriteVocabulary(vocabId: vocabId);
      return Right(res);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          statusCode: e.response?.statusCode ?? 500,
          message: 'something_went_wrong',
        ),
      );
    } catch (e) {
      return Left(
        ApiFailure(
          statusCode: 500,
          message: e.toString(),
        ),
      );
    }
  }

  @override
  ResultFuture<RecentlyLearnedResponse?> getRecentlyLearned() async {
    try {
      final res = await _topicRemoteDataSource.getRecentlyLearned();
      return Right(res);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          statusCode: e.response?.statusCode ?? 500,
          message: 'something_went_wrong',
        ),
      );
    } catch (e) {
      return Left(
        ApiFailure(
          statusCode: 500,
          message: e.toString(),
        ),
      );
    }
  }
}
