import 'package:final_flashcard/features/profile/domain/entities/profile.dart';

class ProfileModel extends Profile {
  const ProfileModel({
    required super.id,
    required super.email,
    required super.name,
    required super.dateOfBirth,
    required super.darkMode,
    required super.language,
    required super.pushNotification,
    required super.saveSets,
    required super.image,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      email: json['email'],
      name: json['fullName'],
      dateOfBirth: DateTime.parse(json['birthDate']),
      darkMode: json['darkMode'],
      language: json['language'],
      pushNotification: json['pushNotification'],
      saveSets: json['saveSetsOffline'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': name,
      'birthDate': dateOfBirth.toString(),
      'darkMode': darkMode,
      'language': language,
      'pushNotification': pushNotification,
      'saveSets': saveSets,
      'image': image,
    };
  }
}
