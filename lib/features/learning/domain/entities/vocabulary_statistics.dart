import 'package:equatable/equatable.dart';
import 'package:final_flashcard/features/authentication/domain/entities/user.dart';
import 'package:final_flashcard/features/topic/domain/entities/vocabulary.dart';

class VocabularyStatistics extends Equatable {
  final int? id;
  final Vocabulary? vocabulary;
  final User? user;
  final int? correctCount;
  final int? incorrectCount;
  final int? totalAnswered;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  const VocabularyStatistics({
    this.id,
    this.vocabulary,
    this.user,
    this.correctCount,
    this.incorrectCount,
    this.totalAnswered,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  @override
  List<Object?> get props => [
        id,
        vocabulary,
        user,
        correctCount,
        incorrectCount,
        totalAnswered,
        createdAt,
        updatedAt,
        deletedAt,
      ];
}
