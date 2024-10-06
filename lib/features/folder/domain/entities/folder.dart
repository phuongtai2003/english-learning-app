import 'package:equatable/equatable.dart';
import 'package:final_flashcard/features/authentication/domain/entities/user.dart';
import 'package:final_flashcard/features/topic/domain/entities/topic.dart';

class Folder extends Equatable {
  final int? id;
  final String? name;
  final String? description;
  final String? image;
  final User? user;
  final List<Topic>? topics;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Folder({
    this.id,
    this.name,
    this.description,
    this.image,
    this.user,
    this.topics,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
      ];
}
