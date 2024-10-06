import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/core/use_case/use_case.dart';
import 'package:final_flashcard/features/profile/domain/repository/profile_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ChangePushNotification implements UseCaseWithParams<bool, bool> {
  final ProfileRepository _profileRepository;

  ChangePushNotification(this._profileRepository);

  @override
  ResultFuture<bool> call(bool params) async {
    return await _profileRepository.changePushNotification(params);
  }
}
