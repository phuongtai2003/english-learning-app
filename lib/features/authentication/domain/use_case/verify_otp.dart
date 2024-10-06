import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/core/use_case/use_case.dart';
import 'package:final_flashcard/features/authentication/domain/repository/authetication_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class VerifyOtp implements UseCaseWithParams<bool, VerifyOtpParams> {
  final AuthenticationRepository _authenticationRepository;

  VerifyOtp(this._authenticationRepository);

  @override
  ResultFuture<bool> call(VerifyOtpParams params) async {
    return await _authenticationRepository.verifyOtp(
        email: params.email, otp: params.otp);
  }
}

class VerifyOtpParams {
  final String otp;
  final String email;

  VerifyOtpParams({
    required this.otp,
    required this.email,
  });
}
