part of 'register_bloc.dart';

@freezed
abstract class RegisterEvent with _$RegisterEvent {
  const factory RegisterEvent.registerAccount({
    required String email,
    required String password,
    required String name,
    required DateTime dateOfBirth,
  }) = RegisterAccountEvent;
  const factory RegisterEvent.showPassword() = ShowPasswordEvent;
  const factory RegisterEvent.showConfirmPassword() = ShowConfirmPasswordEvent;
}
