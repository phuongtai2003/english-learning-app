class ChangeNameRequest {
  final String name;

  ChangeNameRequest({required this.name});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}