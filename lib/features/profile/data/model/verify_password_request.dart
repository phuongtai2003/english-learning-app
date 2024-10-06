class VerifyPasswordRequest {
  final String password;

  VerifyPasswordRequest({required this.password});

  Map<String, dynamic> toJson() {
    return {
      'password': password,
    };
  }
}
