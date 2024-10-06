import 'package:final_flashcard/features/authentication/data/model/user_model.dart';
import 'package:final_flashcard/features/folder/domain/entities/folder.dart';
import 'package:final_flashcard/features/topic/data/model/topic.dart';

class FolderModel extends Folder {
  const FolderModel({
    required int? id,
    required String? name,
    required String? description,
    required String? image,
    required UserModel? user,
    required List<TopicModel>? topics,
    required DateTime? createdAt,
    required DateTime? updatedAt,
  }) : super(
          id: id,
          name: name,
          description: description,
          image: image,
          topics: topics,
          user: user,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory FolderModel.fromJson(Map<String, dynamic> json) {
    print("Hello Tai ${json['user']}");
    return FolderModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      topics: json['topics'] != null
          ? List<TopicModel>.from(
              json['topics'].map(
                (x) => TopicModel.fromJson(x),
              ),
            )
          : null,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'topics': topics,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'user': user != null ? UserModel.fromEntity(user!).toJson() : null,
    };
  }
}
