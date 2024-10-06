part of 'login_bloc.dart';

@freezed
class LoginStateData with _$LoginStateData {
  const factory LoginStateData({
    @Default(false) bool isPasswordVisible,
    @Default('') String error,
  }) = _LoginStateData;
}

@freezed
abstract class LoginState with _$LoginState {
  const factory LoginState.initial(LoginStateData data) = LoginInitial;
  const factory LoginState.loading(LoginStateData data) = LoginLoading;
  const factory LoginState.loginSuccess(LoginStateData data) = LoginSuccess;
  const factory LoginState.loginFailed(LoginStateData data) = LoginFailed;
  const factory LoginState.showPassword(LoginStateData data) = ShowPassword;
  const factory LoginState.requestOtpSuccess(LoginStateData data) =
      RequestOtpSuccess;
  const factory LoginState.requestOtpFailed(LoginStateData data) =
      RequestOtpFailed;
  const factory LoginState.verifyOtpSuccess(LoginStateData data) =
      VerifyOtpSuccess;
  const factory LoginState.verifyOtpFailed(LoginStateData data) =
      VerifyOtpFailed;
  const factory LoginState.resetPasswordSuccess(LoginStateData data) =
      ResetPasswordSuccess;
  const factory LoginState.resetPasswordFailed(LoginStateData data) =
      ResetPasswordFailed;
  const factory LoginState.loginWithGoogleSuccess(LoginStateData data) =
      LoginWithGoogleSuccess;
  const factory LoginState.loginWithGoogleFailed(LoginStateData data) =
      LoginWithGoogleFailed;
}
