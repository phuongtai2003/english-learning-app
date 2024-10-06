import 'package:final_flashcard/features/authentication/data/model/user_model.dart';
import 'package:final_flashcard/features/learning/domain/entities/topic_learning_statistics.dart';
import 'package:final_flashcard/features/topic/data/model/topic.dart';

class TopicLearningStatisticsModel extends TopicLearningStatistics {
  const TopicLearningStatisticsModel({
    required TopicModel? topic,
    required int? id,
    required DateTime? createdAt,
    required DateTime? deletedAt,
    required DateTime? updatedAt,
    required UserModel? user,
    required int? secondsSpent,
    required double? percentageCompleted,
  }) : super(
          topic: topic,
          id: id,
          createdAt: createdAt,
          deletedAt: deletedAt,
          updatedAt: updatedAt,
          user: user,
          secondsSpent: secondsSpent,
          percentageCompleted: percentageCompleted,
        );

  factory TopicLearningStatisticsModel.fromJson(Map<String, dynamic> json) {
    return TopicLearningStatisticsModel(
      topic: json['topic'] != null ? TopicModel.fromJson(json['topic']) : null,
      id: json['id'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      deletedAt:
          json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      secondsSpent: json['secondsSpent'],
      percentageCompleted: json['percentageCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['topic'] =
        topic != null ? TopicModel.fromEntity(topic!).toJson() : null;
    data['id'] = id;
    data['createdAt'] = createdAt?.toIso8601String();
    data['deletedAt'] = deletedAt?.toIso8601String();
    data['updatedAt'] = updatedAt?.toIso8601String();
    data['user'] = user != null ? UserModel.fromEntity(user!).toJson() : null;
    data['secondsSpent'] = secondsSpent;
    data['percentageCompleted'] = percentageCompleted;
    return data;
  }

  factory TopicLearningStatisticsModel.fromEntity(
          TopicLearningStatistics entity) =>
      TopicLearningStatisticsModel(
        topic:
            entity.topic != null ? TopicModel.fromEntity(entity.topic!) : null,
        id: entity.id,
        createdAt: entity.createdAt,
        deletedAt: entity.deletedAt,
        updatedAt: entity.updatedAt,
        user: entity.user != null ? UserModel.fromEntity(entity.user!) : null,
        secondsSpent: entity.secondsSpent,
        percentageCompleted: entity.percentageCompleted,
      );
}
