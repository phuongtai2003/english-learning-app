import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/core/use_case/use_case.dart';
import 'package:final_flashcard/features/authentication/domain/repository/authetication_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SocialLogin implements UseCaseWithParams<void, String> {
  final AuthenticationRepository _repository;

  SocialLogin(this._repository);
  @override
  ResultFuture<void> call(String params) async {
    return await _repository.loginWithGoogle(idToken: params);
  }
}
