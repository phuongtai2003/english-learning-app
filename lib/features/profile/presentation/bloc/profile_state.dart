part of 'profile_bloc.dart';

@freezed
class ProfileStateData with _$ProfileStateData {
  const factory ProfileStateData({
    @Default('') String error,
    Profile? profile,
  }) = _ProfileStateData;
}

@freezed
abstract class ProfileState with _$ProfileState {
  const factory ProfileState.initial(ProfileStateData data) = ProfileInitial;
  const factory ProfileState.loading(ProfileStateData data) = ProfileLoading;
  const factory ProfileState.loaded(ProfileStateData data) = ProfileLoaded;
  const factory ProfileState.error(ProfileStateData data) = ProfileError;
  const factory ProfileState.logout(ProfileStateData data) = ProfileLogout;
  const factory ProfileState.changeDarkMode(ProfileStateData data) =
      ProfileChangeDarkMode;
  const factory ProfileState.changeLanguage(ProfileStateData data) =
      ProfileChangeLanguage;
  const factory ProfileState.changePushNotification(ProfileStateData data) =
      ProfileChangePushNotification;
  const factory ProfileState.changeSaveSets(ProfileStateData data) =
      ProfileChangeSaveSets;
  const factory ProfileState.pickImage(ProfileStateData data) =
      ProfilePickImage;
  const factory ProfileState.changeNameSuccess(ProfileStateData data) =
      ProfileChangeNameSuccess;
  const factory ProfileState.changeNameError(ProfileStateData data) =
      ProfileChangeNameError;
  const factory ProfileState.changeNameLoading(ProfileStateData data) =
      ProfileChangeNameLoading;
  const factory ProfileState.verifyPasswordSuccess(ProfileStateData data) =
      ProfileVerifyPasswordSuccess;
  const factory ProfileState.verifyPasswordError(ProfileStateData data) =
      ProfileVerifyPasswordError;
  const factory ProfileState.verifyPasswordLoading(ProfileStateData data) =
      ProfileVerifyPasswordLoading;
  const factory ProfileState.sendOtpNewEmailSuccess(ProfileStateData data) =
      ProfileSendOtpNewEmailSuccess;
  const factory ProfileState.sendOtpNewEmailError(ProfileStateData data) =
      ProfileSendOtpNewEmailError;
  const factory ProfileState.sendOtpNewEmailLoading(ProfileStateData data) =
      ProfileSendOtpNewEmailLoading;
  const factory ProfileState.verifyNewEmailSuccess(ProfileStateData data) =
      ProfileVerifyNewEmailSuccess;
  const factory ProfileState.verifyNewEmailError(ProfileStateData data) =
      ProfileVerifyNewEmailError;
  const factory ProfileState.verifyNewEmailLoading(ProfileStateData data) =
      ProfileVerifyNewEmailLoading;
  const factory ProfileState.changePasswordSuccess(ProfileStateData data) =
      ProfileChangePasswordSuccess;
  const factory ProfileState.changePasswordError(ProfileStateData data) =
      ProfileChangePasswordError;
  const factory ProfileState.changePasswordLoading(ProfileStateData data) =
      ProfileChangePasswordLoading;
}
