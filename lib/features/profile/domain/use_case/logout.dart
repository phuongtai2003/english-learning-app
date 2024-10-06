import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/core/use_case/use_case.dart';
import 'package:final_flashcard/features/profile/domain/repository/profile_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class Logout implements UseCaseWithoutParams<void> {
  final ProfileRepository _profileRepository;

  const Logout(this._profileRepository);

  @override
  ResultVoid call() async {
    return await _profileRepository.logout();
  }
}
