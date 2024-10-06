class ChangeEmailRequest {
  final String newEmail;
  final String otp;

  ChangeEmailRequest({
    required this.newEmail,
    required this.otp,
  });

  toJson() {
    return {
      'newEmail': newEmail,
      'otp': otp,
    };
  }
}