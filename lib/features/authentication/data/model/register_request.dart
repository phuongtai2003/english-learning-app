class RegistrationRequest {
  final String email;
  final String password;
  final String name;
  final DateTime dateOfBirth;

  RegistrationRequest({
    required this.email,
    required this.password,
    required this.name,
    required this.dateOfBirth,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'name': name,
      'dateOfBirth': dateOfBirth.toIso8601String(),
    };
  }
}
