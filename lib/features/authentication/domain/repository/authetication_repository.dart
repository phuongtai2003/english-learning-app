import 'package:final_flashcard/core/data/typedef.dart';

abstract class AuthenticationRepository {
  const AuthenticationRepository();
  ResultVoid createUser({
    required String email,
    required String password,
    required String name,
    required DateTime dateOfBirth,
  });
  ResultVoid loginAccount({
    required String email,
    required String password,
  });
  ResultFuture<DataMap> getEmailAndPassword();
  ResultVoid requestOtpPassword(String email);
  ResultFuture<bool> verifyOtp({
    required String otp,
    required String email,
  });
  ResultVoid resetPassword({
    required String email,
    required String password,
  });
  ResultVoid loginWithGoogle({
    required String idToken,
  });
}
