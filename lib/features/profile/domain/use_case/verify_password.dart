import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/core/use_case/use_case.dart';
import 'package:final_flashcard/features/profile/domain/repository/profile_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class VerifyPasswordUseCase implements UseCaseWithParams<bool, String> {
  final ProfileRepository _profileRepository;

  VerifyPasswordUseCase(this._profileRepository);

  @override
  ResultFuture<bool> call(String params) async {
    return await _profileRepository.verifyPassword(params);
  }
}
