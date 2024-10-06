import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/core/use_case/use_case.dart';
import 'package:final_flashcard/features/profile/domain/repository/profile_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ChangePasswordUseCase
    implements UseCaseWithParams<bool, ChangePasswordParams> {
  final ProfileRepository _profileRepository;

  const ChangePasswordUseCase(this._profileRepository);

  @override
  ResultFuture<bool> call(ChangePasswordParams params) async {
    return await _profileRepository.changePassword(
      params.oldPassword,
      params.newPassword,
    );
  }
}

class ChangePasswordParams {
  final String oldPassword;
  final String newPassword;

  const ChangePasswordParams(
      {required this.oldPassword, required this.newPassword});
}
