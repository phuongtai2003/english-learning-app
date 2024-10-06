import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/core/use_case/use_case.dart';
import 'package:final_flashcard/features/topic/domain/repository/topic_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AddTopicUseCase implements UseCaseWithParams<bool, AddTopicParams> {
  final TopicRepository _topicRepository;

  AddTopicUseCase(this._topicRepository);
  @override
  ResultFuture<bool> call(AddTopicParams params) async {
    return await _topicRepository.addTopic(
      topicName: params.topicName,
      topicDescription: params.topicDescription,
      isPublic: params.isPublic,
      images: params.images,
      termLanguage: params.termLanguage,
      definitionLanguage: params.definitionLanguage,
      indexes: params.indexes,
      terms: params.terms,
      definitions: params.definitions,
    );
  }
}

class AddTopicParams extends Equatable {
  final String topicName;
  final String topicDescription;
  final bool isPublic;
  final List<File> images;
  final String termLanguage;
  final String definitionLanguage;
  final List<String> terms;
  final List<String> definitions;
  final List<int> indexes;

  const AddTopicParams({
    required this.topicName,
    required this.topicDescription,
    required this.isPublic,
    required this.images,
    required this.termLanguage,
    required this.definitionLanguage,
    required this.indexes,
    required this.terms,
    required this.definitions,
  });

  toJson() {
    return {
      "topicName": topicName,
      "topicDescription": topicDescription,
      "isPublic": isPublic,
      "images": images,
      "termLanguage": termLanguage,
      "definitionLanguage": definitionLanguage,
      "terms": terms,
      "definitions": definitions,
      "indexes": indexes,
    };
  }

  @override
  List<Object?> get props => [
        topicName,
        topicDescription,
        isPublic,
        images,
        termLanguage,
        definitionLanguage,
        terms,
        definitions,
      ];
}
