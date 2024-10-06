import 'package:equatable/equatable.dart';
import 'package:final_flashcard/features/authentication/domain/entities/user.dart';
import 'package:final_flashcard/features/topic/domain/entities/topic.dart';

class TopicLearningStatistics extends Equatable {
  final int? id;
  final Topic? topic;
  final User? user;
  final int? secondsSpent;
  final double? percentageCompleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  const TopicLearningStatistics({
    this.id,
    this.topic,
    this.user,
    this.secondsSpent,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.percentageCompleted,
  });

  @override
  List<Object?> get props => [
        id,
        topic,
        user,
        secondsSpent,
        createdAt,
        updatedAt,
        deletedAt,
        percentageCompleted,
      ];

  TopicLearningStatistics copyWith({
    int? id,
    Topic? topic,
    User? user,
    int? secondsSpent,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? percentageCompleted,
    DateTime? deletedAt,
  }) {
    return TopicLearningStatistics(
      id: id ?? this.id,
      topic: topic ?? this.topic,
      user: user ?? this.user,
      secondsSpent: secondsSpent ?? this.secondsSpent,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      percentageCompleted: percentageCompleted ?? this.percentageCompleted,
    );
  }
}
