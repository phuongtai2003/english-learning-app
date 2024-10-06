import 'dart:io';

import 'package:equatable/equatable.dart';

class FlashCardVocabulary extends Equatable {
  final int? id;
  final String? term;
  final String? definition;
  final File? image;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  const FlashCardVocabulary({
    required this.id,
    required this.term,
    required this.definition,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  copyWith({
    int? id,
    String? term,
    String? definition,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    required File? image,
  }) {
    return FlashCardVocabulary(
      id: id ?? this.id,
      term: term ?? this.term,
      definition: definition ?? this.definition,
      image: image,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  List<Object?> get props => [id];
}
