import 'package:equatable/equatable.dart';

class Vocabulary extends Equatable {
  final int? id;
  final String? term;
  final String? definition;
  final String? image;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  const Vocabulary({
    required this.id,
    required this.term,
    required this.definition,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  @override
  List<Object?> get props => [id];
}
