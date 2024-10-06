import 'package:final_flashcard/features/authentication/data/model/user_model.dart';
import 'package:final_flashcard/features/topic/data/model/vocabulary.dart';
import 'package:final_flashcard/features/topic/domain/entities/topic.dart';

class TopicModel extends Topic {
  const TopicModel({
    required int? id,
    required String? title,
    required String? description,
    required int? vocabularyCount,
    required String? image,
    required String? termLocale,
    required String? definitionLocale,
    required UserModel? user,
    required List<VocabularyModel>? vocabularies,
    required bool? isPublic,
    required DateTime? createdAt,
    required DateTime? updatedAt,
    required bool? isDownloaded,
  }) : super(
          id: id,
          title: title,
          description: description,
          vocabularyCount: vocabularyCount,
          image: image,
          termLocale: termLocale,
          definitionLocale: definitionLocale,
          user: user,
          vocabularies: vocabularies,
          isPublic: isPublic,
          createdAt: createdAt,
          updatedAt: updatedAt,
          isDownloaded: isDownloaded,
        );

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      vocabularyCount: json['vocabularyCount'],
      image: json['image'],
      termLocale: json['termLocale'],
      definitionLocale: json['definitionLocale'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      vocabularies: json['vocabularies'] != null
          ? json['vocabularies']
              .map<VocabularyModel>((e) => VocabularyModel.fromJson(e))
              .toList()
          : [],
      isPublic: json['isPublic'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isDownloaded: json['isDownloaded'],
    );
  }

  factory TopicModel.fromEntity(Topic topic) {
    return TopicModel(
      id: topic.id,
      title: topic.title,
      description: topic.description,
      vocabularyCount: topic.vocabularyCount,
      image: topic.image,
      termLocale: topic.termLocale,
      definitionLocale: topic.definitionLocale,
      user: topic.user != null ? UserModel.fromEntity(topic.user!) : null,
      vocabularies: topic.vocabularies != null
          ? topic.vocabularies!
              .map((e) => VocabularyModel.fromEntity(e))
              .toList()
          : [],
      isPublic: topic.isPublic,
      createdAt: topic.createdAt,
      updatedAt: topic.updatedAt,
      isDownloaded: topic.isDownloaded,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'vocabularyCount': vocabularyCount,
      'image': image,
      'termLocale': termLocale,
      'definitionLocale': definitionLocale,
      'user': user,
      'vocabularies': vocabularies,
      'isPublic': isPublic,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isDownloaded': isDownloaded,
    };
  }
}
