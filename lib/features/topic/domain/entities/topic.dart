// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:final_flashcard/features/authentication/domain/entities/user.dart';
import 'package:final_flashcard/features/topic/domain/entities/vocabulary.dart';

class Topic extends Equatable {
  final int? id;
  final String? title;
  final String? description;
  final int? vocabularyCount;
  final String? image;
  final String? termLocale;
  final String? definitionLocale;
  final User? user;
  final List<Vocabulary>? vocabularies;
  final bool? isPublic;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isDownloaded;

  const Topic({
    required this.id,
    required this.title,
    required this.description,
    required this.vocabularyCount,
    required this.image,
    required this.termLocale,
    required this.definitionLocale,
    required this.user,
    required this.vocabularies,
    required this.isPublic,
    required this.createdAt,
    required this.updatedAt,
    this.isDownloaded,
  });

  @override
  List<Object?> get props => [id];

  Topic copyWith({
    int? id,
    String? title,
    String? description,
    int? vocabularyCount,
    String? image,
    String? termLocale,
    String? definitionLocale,
    User? user,
    List<Vocabulary>? vocabularies,
    bool? isPublic,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDownloaded,
  }) {
    return Topic(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      vocabularyCount: vocabularyCount ?? this.vocabularyCount,
      image: image ?? this.image,
      termLocale: termLocale ?? this.termLocale,
      definitionLocale: definitionLocale ?? this.definitionLocale,
      user: user ?? this.user,
      vocabularies: vocabularies ?? this.vocabularies,
      isPublic: isPublic ?? this.isPublic,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDownloaded: isDownloaded ?? this.isDownloaded,
    );
  }
}
