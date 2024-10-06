import 'package:final_flashcard/core/errors/failure.dart';
import 'package:final_flashcard/features/authentication/domain/use_case/registration.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_event.dart';
part 'register_state.dart';

part 'register_bloc.freezed.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegistrationUseCase _registrationUseCase;
  RegisterBloc(this._registrationUseCase)
      : super(const RegisterInitial(RegisterStateData())) {
    on<RegisterAccountEvent>(_onRegisterAccount);
    on<ShowPasswordEvent>(_onShowPassword);
    on<ShowConfirmPasswordEvent>(_onShowConfirmPassword);
  }

  void _onRegisterAccount(
    RegisterAccountEvent event,
    Emitter<RegisterState> emit,
  ) async {
    try {
      emit(
        RegisterLoading(
          state.data,
        ),
      );
      final res = await _registrationUseCase(
        RegistrationParams(
          email: event.email,
          password: event.password,
          name: event.name,
          dateOfBirth: event.dateOfBirth,
        ),
      );
      res.fold(
        (failure) {
          emit(
            RegisterError(
              state.data.copyWith(
                error: failure.message,
              ),
            ),
          );
        },
        (success) => {
          emit(
            RegisterSuccess(
              state.data,
            ),
          )
        },
      );
    } on ApiFailure catch (e) {
      emit(
        RegisterError(
          state.data.copyWith(
            error: e.message,
          ),
        ),
      );
    } catch (e) {
      emit(
        RegisterError(
          state.data.copyWith(
            error: e.toString(),
          ),
        ),
      );
    }
  }

  void _onShowPassword(
    ShowPasswordEvent event,
    Emitter<RegisterState> emit,
  ) {
    emit(
      ShowPassword(
        state.data.copyWith(
          isShowPassword: state.data.isShowPassword == true ? false : true,
        ),
      ),
    );
  }

  void _onShowConfirmPassword(
    ShowConfirmPasswordEvent event,
    Emitter<RegisterState> emit,
  ) {
    emit(
      ShowPassword(
        state.data.copyWith(
          isShowConfirmPassword:
              state.data.isShowConfirmPassword == true ? false : true,
        ),
      ),
    );
  }
}
