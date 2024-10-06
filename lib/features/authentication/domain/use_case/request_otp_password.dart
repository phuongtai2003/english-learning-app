import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/core/use_case/use_case.dart';
import 'package:final_flashcard/features/authentication/domain/repository/authetication_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class RequestOtpPassword implements UseCaseWithParams<void, String> {
  final AuthenticationRepository _authenticationRepository;

  RequestOtpPassword(this._authenticationRepository);

  @override
  ResultVoid call(String params) async {
    return await _authenticationRepository.requestOtpPassword(params);
  }
}
