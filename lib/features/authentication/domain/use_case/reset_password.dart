import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/core/use_case/use_case.dart';
import 'package:final_flashcard/features/authentication/domain/repository/authetication_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ResetPassword implements UseCaseWithParams<void, ResetPasswordParams> {
  final AuthenticationRepository _authenticationRepository;

  ResetPassword(this._authenticationRepository);

  @override
  ResultVoid call(ResetPasswordParams params) async {
    return await _authenticationRepository.resetPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class ResetPasswordParams {
  final String email;
  final String password;

  ResetPasswordParams({
    required this.email,
    required this.password,
  });
}
