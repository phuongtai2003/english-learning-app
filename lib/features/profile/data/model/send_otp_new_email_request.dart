class SendOtpNewEmailRequest {
  final String? newEmail;

  SendOtpNewEmailRequest({this.newEmail});

  toJson() {
    return {
      'newEmail': newEmail,
    };
  }

  factory SendOtpNewEmailRequest.fromJson(Map<String, dynamic> json) {
    return SendOtpNewEmailRequest(
      newEmail: json['newEmail'],
    );
  }
}
