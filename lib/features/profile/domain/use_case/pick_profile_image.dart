import 'dart:io';

import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/core/use_case/use_case.dart';
import 'package:final_flashcard/features/profile/domain/repository/profile_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class PickProfileImage implements UseCaseWithParams<String, File> {
  final ProfileRepository _profileRepository;

  PickProfileImage(this._profileRepository);

  @override
  ResultFuture<String> call(File image) async {
    return await _profileRepository.pickProfileImage(image);
  }
}
