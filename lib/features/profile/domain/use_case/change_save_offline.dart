import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/core/use_case/use_case.dart';
import 'package:final_flashcard/features/profile/domain/repository/profile_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ChangeSaveOffline implements UseCaseWithParams<bool, bool> {
  final ProfileRepository _profileRepository;

  ChangeSaveOffline(this._profileRepository);

  @override
  ResultFuture<bool> call(bool saveOffline) async {
    return await _profileRepository.changeSaveOffline(saveOffline);
  }
}
