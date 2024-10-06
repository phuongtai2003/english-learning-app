class ResetPasswordRequest {
  final String email;
  final String password;

  ResetPasswordRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}
