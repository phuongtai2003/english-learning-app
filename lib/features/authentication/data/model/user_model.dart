import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/features/authentication/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.image,
    required super.id,
    required super.email,
    required super.name,
    required super.dateOfBirth,
    required super.createdAt,
    required super.updatedAt,
  });

  factory UserModel.fromJson(DataMap json) => UserModel(
        id: json['id'],
        email: json['email'],
        name: json['fullName'],
        dateOfBirth: json['birthDate'] == null
            ? null
            : DateTime.parse(json['birthDate']),
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt']),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt']),
        image: json['image'],
      );

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      dateOfBirth: user.dateOfBirth,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      image: user.image,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'fullName': name,
        'birthDate': dateOfBirth?.toIso8601String(),
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'image': image,
      };

  UserModel copyWith({
    int? id,
    String? email,
    String? name,
    DateTime? dateOfBirth,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? image,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      image: image ?? this.image,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
