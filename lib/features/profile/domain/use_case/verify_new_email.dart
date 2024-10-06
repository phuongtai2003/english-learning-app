import 'package:equatable/equatable.dart';
import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/core/use_case/use_case.dart';
import 'package:final_flashcard/features/profile/domain/repository/profile_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class VerifyNewEmailUseCase
    implements UseCaseWithParams<String, VerifyNewEmailParams> {
  final ProfileRepository _profileRepository;

  const VerifyNewEmailUseCase(this._profileRepository);

  @override
  ResultFuture<String> call(VerifyNewEmailParams params) async {
    return await _profileRepository.changeEmail(params.email, params.otp);
  }
}

class VerifyNewEmailParams extends Equatable {
  final String email;
  final String otp;

  const VerifyNewEmailParams({required this.email, required this.otp});

  @override
  List<Object?> get props => [email, otp];
}
