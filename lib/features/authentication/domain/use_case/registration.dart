import 'package:equatable/equatable.dart';
import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/core/use_case/use_case.dart';
import 'package:final_flashcard/features/authentication/domain/repository/authetication_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class RegistrationUseCase implements UseCaseWithParams<void, RegistrationParams> {
  final AuthenticationRepository _authenticationRepository;

  const RegistrationUseCase(this._authenticationRepository);

  @override
  ResultVoid call(RegistrationParams params) async =>
      await _authenticationRepository.createUser(
        email: params.email,
        password: params.password,
        name: params.name,
        dateOfBirth: params.dateOfBirth,
      );
}

class RegistrationParams extends Equatable {
  final String email;
  final String password;
  final String name;
  final DateTime dateOfBirth;

  const RegistrationParams({
    required this.email,
    required this.password,
    required this.name,
    required this.dateOfBirth,
  });

  @override
  List<Object?> get props => [email, password, name, dateOfBirth];
}
