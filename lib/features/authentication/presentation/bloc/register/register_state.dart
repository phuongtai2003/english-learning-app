part of 'register_bloc.dart';

@freezed
class RegisterStateData with _$RegisterStateData {
  const factory RegisterStateData({
    @Default('') String error,
    @Default(false) bool isShowPassword,
    @Default(false) bool isShowConfirmPassword,
  }) = _RegisterStateData;
}

@freezed
abstract class RegisterState with _$RegisterState {
  const factory RegisterState.initial(RegisterStateData data) =
      RegisterInitial;
  const factory RegisterState.loading(RegisterStateData data) =
      RegisterLoading;
  const factory RegisterState.registerSuccess(RegisterStateData data) =
      RegisterSuccess;
  const factory RegisterState.error(RegisterStateData data) = RegisterError;
  const factory RegisterState.showPassword(RegisterStateData data) =
      ShowPassword;
}
