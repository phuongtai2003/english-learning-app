class VerifyOtpRequest {
  final String email;
  final String otp;

  VerifyOtpRequest({
    required this.email,
    required this.otp,
  });

  toJson() => {
        "email": email,
        "otp": otp,
      };
}
