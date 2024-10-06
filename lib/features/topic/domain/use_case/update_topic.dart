import 'dart:io';

import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/core/use_case/use_case.dart';
import 'package:final_flashcard/features/topic/domain/entities/topic.dart';
import 'package:final_flashcard/features/topic/domain/repository/topic_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class UpdateTopicUseCase
    implements UseCaseWithParams<Topic, UpdateTopicParams> {
  final TopicRepository _topicRepository;

  UpdateTopicUseCase(this._topicRepository);

  @override
  ResultFuture<Topic> call(UpdateTopicParams params) async {
    return await _topicRepository.updateTopic(
      topicId: params.topicId,
      topicName: params.topicName,
      topicDescription: params.topicDescription,
      definitionLanguage: params.definitionLanguage,
      termLanguage: params.termLanguage,
      oldVocabulariesIds: params.oldVocabulariesIds,
      oldVocabulariesTerms: params.oldVocabulariesTerms,
      oldVocabulariesDefinitions: params.oldVocabulariesDefinitions,
      newVocabulariesTerms: params.newVocabulariesTerms,
      newVocabulariesDefinitions: params.newVocabulariesDefinitions,
      deletedVocabulariesIds: params.deletedVocabulariesIds,
      imagesList: params.imagesList,
      hasImages: params.hasImages,
    );
  }
}

class UpdateTopicParams {
  final int topicId;
  final String topicName;
  final String topicDescription;
  final String definitionLanguage;
  final String termLanguage;
  final List<String> oldVocabulariesIds;
  final List<String> oldVocabulariesTerms;
  final List<String> oldVocabulariesDefinitions;
  final List<String> newVocabulariesTerms;
  final List<String> newVocabulariesDefinitions;
  final List<String> deletedVocabulariesIds;
  final List<File> imagesList;
  final List<String> hasImages;

  const UpdateTopicParams({
    required this.topicId,
    required this.topicName,
    required this.topicDescription,
    required this.definitionLanguage,
    required this.termLanguage,
    required this.oldVocabulariesIds,
    required this.oldVocabulariesTerms,
    required this.oldVocabulariesDefinitions,
    required this.newVocabulariesTerms,
    required this.newVocabulariesDefinitions,
    required this.deletedVocabulariesIds,
    required this.imagesList,
    required this.hasImages,
  });

  toJson() => {
        'topicId': topicId,
        'topicName': topicName,
        'topicDescription': topicDescription,
        'definitionLanguage': definitionLanguage,
        'termLanguage': termLanguage,
        'oldVocabulariesIds': oldVocabulariesIds,
        'oldVocabulariesTerms': oldVocabulariesTerms,
        'oldVocabulariesDefinitions': oldVocabulariesDefinitions,
        'newVocabulariesTerms': newVocabulariesTerms,
        'newVocabulariesDefinitions': newVocabulariesDefinitions,
        'deletedVocabulariesIds': deletedVocabulariesIds,
        'imagesList': imagesList,
        'hasImages': hasImages,
      };
}
