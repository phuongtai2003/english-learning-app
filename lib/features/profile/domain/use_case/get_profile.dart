import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/core/use_case/use_case.dart';
import 'package:final_flashcard/features/profile/domain/entities/profile.dart';
import 'package:final_flashcard/features/profile/domain/repository/profile_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetProfile implements UseCaseWithoutParams<Profile> {
  final ProfileRepository _profileRepository;

  GetProfile(this._profileRepository);

  @override
  ResultFuture<Profile> call() async {
    return await _profileRepository.getProfile();
  }
}
