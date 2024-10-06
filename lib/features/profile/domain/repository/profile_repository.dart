import 'dart:io';

import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/features/profile/domain/entities/profile.dart';

abstract class ProfileRepository {
  const ProfileRepository();

  ResultVoid logout();
  ResultVoid changeDarkMode(bool darkMode);
  ResultFuture<Profile> getProfile();
  ResultVoid changeLanguage(String language);
  ResultFuture<bool> changePushNotification(bool pushNotification);
  ResultFuture<bool> changeSaveOffline(bool saveOffline);
  ResultFuture<String> pickProfileImage(File image);
  ResultFuture<Profile> changeName(String name);
  ResultFuture<bool> verifyPassword(String password);
  ResultFuture<bool> sendOtpNewEmail(String email);
  ResultFuture<String> changeEmail(String email, String otp);
  ResultFuture<bool> changePassword(String oldPassword, String newPassword);
}
