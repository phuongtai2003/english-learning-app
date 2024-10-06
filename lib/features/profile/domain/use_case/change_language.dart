import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/core/use_case/use_case.dart';
import 'package:final_flashcard/features/profile/domain/repository/profile_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ChangeLanguage implements UseCaseWithParams<void, String> {
  final ProfileRepository _profileRepository;

  ChangeLanguage(this._profileRepository);

  @override
  ResultVoid call(String params) async {
    return await _profileRepository.changeLanguage(params);
  }
}
