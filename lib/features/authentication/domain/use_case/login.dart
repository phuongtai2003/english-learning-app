import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/core/use_case/use_case.dart';
import 'package:final_flashcard/features/authentication/domain/repository/authetication_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class LoginUseCase implements UseCaseWithParams<void, LoginParams> {
  final AuthenticationRepository _authenticationRepository;

  const LoginUseCase(this._authenticationRepository);

  @override
  ResultVoid call(LoginParams params) async {
    return await _authenticationRepository.loginAccount(
      email: params.email,
      password: params.password,
    );
  }
}

class LoginParams {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });
}
