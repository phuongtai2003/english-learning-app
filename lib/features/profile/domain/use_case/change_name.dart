import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/core/use_case/use_case.dart';
import 'package:final_flashcard/features/profile/domain/entities/profile.dart';
import 'package:final_flashcard/features/profile/domain/repository/profile_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ChangeNameUseCase implements UseCaseWithParams<Profile, String> {
  final ProfileRepository _profileRepository;

  ChangeNameUseCase(this._profileRepository);

  @override
  ResultFuture<Profile> call(String params) async {
    return await _profileRepository.changeName(params);
  }
}
