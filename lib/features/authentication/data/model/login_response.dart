import 'package:final_flashcard/features/authentication/data/model/user_model.dart';

class LoginResponse {
  final String token;
  final UserModel user;

  LoginResponse({required this.token, required this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
      user: UserModel.fromJson(json['user']),
    );
  }

  toJson() {
    return {
      'token': token,
      'user': user.toJson(),
    };
  }
}
