import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/core/use_case/use_case.dart';
import 'package:final_flashcard/features/profile/domain/repository/profile_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ChangeDarkMode implements UseCaseWithParams<void, bool> {
  final ProfileRepository _profileRepository;

  ChangeDarkMode(this._profileRepository);

  @override
  ResultVoid call(bool params) async {
    return await _profileRepository.changeDarkMode(params);
  }
}
