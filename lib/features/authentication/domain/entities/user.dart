import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int? id;
  final String? email;
  final String? name;
  final String? image;
  final DateTime? dateOfBirth;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.dateOfBirth,
    required this.createdAt,
    required this.updatedAt,
    required this.image,
  });

  @override
  List<Object?> get props => [id];
}
