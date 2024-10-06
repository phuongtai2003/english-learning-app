part of 'profile_bloc.dart';

@freezed
abstract class ProfileEvent with _$ProfileEvent {
  const factory ProfileEvent.logout() = ProfileLogoutEvent;
  const factory ProfileEvent.changeDarkMode(bool darkMode) =
      ProfileChangeDarkModeEvent;
  const factory ProfileEvent.getProfile() = ProfileGetProfileEvent;
  const factory ProfileEvent.changeLanguage(String language) =
      ProfileChangeLanguageEvent;
  const factory ProfileEvent.changePushNotification(bool pushNotification) =
      ProfileChangePushNotificationEvent;
  const factory ProfileEvent.changeSaveSets(bool saveSets) =
      ProfileChangeSaveSetsEvent;
  const factory ProfileEvent.pickImage(File image) = ProfilePickImageEvent;
  const factory ProfileEvent.changeName(String name) = ProfileChangeNameEvent;
  const factory ProfileEvent.verifyPassword(String password) =
      ProfileVerifyPasswordEvent;
  const factory ProfileEvent.sendOtpNewEmail(String email) =
      ProfileSendOtpNewEmailEvent;
  const factory ProfileEvent.verifyNewEmail(String email, String otp) =
      ProfileVerifyNewEmailEvent;
  const factory ProfileEvent.changePassword(
      String oldPassword, String newPassword) = ProfileChangePasswordEvent;
}
