part of 'login_bloc.dart';

@freezed
abstract class LoginEvent with _$LoginEvent {
  const factory LoginEvent.loginAccount({
    required String email,
    required String password,
  }) = LoginAccountEvent;
  const factory LoginEvent.showPassword({
    required bool isShow,
  }) = ShowPasswordEvent;
  const factory LoginEvent.requestOtp({
    required String email,
  }) = RequestOtpEvent;
  const factory LoginEvent.verifyOtp({
    required String otp,
    required String email,
  }) = VerifyOtpEvent;
  const factory LoginEvent.resetPassword({
    required String email,
    required String password,
  }) = ResetPasswordEvent;
  const factory LoginEvent.loginWithGoogle() = LoginWithGoogleEvent;
}
