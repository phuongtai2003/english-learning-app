import 'dart:async';

import 'package:final_flashcard/core/errors/failure.dart';
import 'package:final_flashcard/features/authentication/domain/use_case/login.dart';
import 'package:final_flashcard/features/authentication/domain/use_case/request_otp_password.dart';
import 'package:final_flashcard/features/authentication/domain/use_case/reset_password.dart';
import 'package:final_flashcard/features/authentication/domain/use_case/social_login.dart';
import 'package:final_flashcard/features/authentication/domain/use_case/verify_otp.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'login_event.dart';
part 'login_state.dart';
part 'login_bloc.freezed.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase _loginUseCase;
  final RequestOtpPassword _requestOtpPassword;
  final VerifyOtp _verifyOtp;
  final ResetPassword _resetPassword;
  final GoogleSignIn _googleSignIn;
  final SocialLogin _socialLogin;
  LoginBloc(
    this._loginUseCase,
    this._requestOtpPassword,
    this._verifyOtp,
    this._resetPassword,
    this._googleSignIn,
    this._socialLogin,
  ) : super(const LoginInitial(LoginStateData())) {
    on<LoginAccountEvent>(_loginAccount);
    on<ShowPasswordEvent>(_showPassword);
    on<RequestOtpEvent>(_requestOtp);
    on<VerifyOtpEvent>(_verifyOtpEvent);
    on<ResetPasswordEvent>(_resetPasswordEvent);
    on<LoginWithGoogleEvent>(_loginWithGoogleEvent);
  }

  void _resetPasswordEvent(
      ResetPasswordEvent event, Emitter<LoginState> emit) async {
    try {
      emit(
        LoginLoading(
          state.data,
        ),
      );
      final res = await _resetPassword(
        ResetPasswordParams(
          email: event.email,
          password: event.password,
        ),
      );
      res.fold(
        (l) {
          emit(
            ResetPasswordFailed(
              state.data.copyWith(
                error: l.message,
              ),
            ),
          );
        },
        (r) {
          emit(
            ResetPasswordSuccess(
              state.data,
            ),
          );
        },
      );
    } on ApiFailure catch (e) {
      emit(
        ResetPasswordFailed(
          state.data.copyWith(
            error: e.message,
          ),
        ),
      );
    } catch (e) {
      emit(
        ResetPasswordFailed(
          state.data.copyWith(
            error: e.toString(),
          ),
        ),
      );
    }
  }

  void _verifyOtpEvent(VerifyOtpEvent event, Emitter<LoginState> emit) async {
    try {
      emit(
        LoginLoading(
          state.data,
        ),
      );
      final res = await _verifyOtp(
        VerifyOtpParams(
          email: event.email,
          otp: event.otp,
        ),
      );
      res.fold(
        (l) {
          emit(
            VerifyOtpFailed(
              state.data.copyWith(
                error: l.message,
              ),
            ),
          );
        },
        (r) {
          if (r) {
            emit(
              VerifyOtpSuccess(
                state.data,
              ),
            );
          } else {
            emit(
              VerifyOtpFailed(
                state.data.copyWith(
                  error: 'invalid_otp',
                ),
              ),
            );
          }
        },
      );
    } on ApiFailure catch (e) {
      emit(
        VerifyOtpFailed(
          state.data.copyWith(
            error: e.message,
          ),
        ),
      );
    } catch (e) {
      emit(
        VerifyOtpFailed(
          state.data.copyWith(
            error: e.toString(),
          ),
        ),
      );
    }
  }

  void _requestOtp(RequestOtpEvent event, Emitter<LoginState> emit) async {
    try {
      emit(
        LoginLoading(
          state.data,
        ),
      );
      final res = await _requestOtpPassword(
        event.email,
      );
      res.fold(
        (l) {
          emit(
            RequestOtpFailed(
              state.data.copyWith(
                error: l.message,
              ),
            ),
          );
        },
        (r) {
          emit(
            RequestOtpSuccess(
              state.data,
            ),
          );
        },
      );
    } on ApiFailure catch (e) {
      emit(
        RequestOtpFailed(
          state.data.copyWith(
            error: e.message,
          ),
        ),
      );
    } catch (e) {
      emit(
        RequestOtpFailed(
          state.data.copyWith(
            error: e.toString(),
          ),
        ),
      );
    }
  }

  void _loginAccount(LoginAccountEvent event, Emitter<LoginState> emit) async {
    try {
      emit(
        LoginLoading(
          state.data,
        ),
      );
      final res = await _loginUseCase(
        LoginParams(
          email: event.email,
          password: event.password,
        ),
      );
      res.fold(
        (l) {
          emit(
            LoginFailed(
              state.data.copyWith(
                error: l.message,
              ),
            ),
          );
        },
        (r) {
          emit(
            LoginSuccess(
              state.data,
            ),
          );
        },
      );
    } on ApiFailure catch (e) {
      emit(
        LoginFailed(
          state.data.copyWith(
            error: e.message,
          ),
        ),
      );
    } catch (e) {
      emit(
        LoginFailed(
          state.data.copyWith(
            error: e.toString(),
          ),
        ),
      );
    }
  }

  void _showPassword(ShowPasswordEvent event, Emitter<LoginState> emit) {
    emit(
      ShowPassword(
        state.data.copyWith(
          isPasswordVisible: event.isShow,
        ),
      ),
    );
  }

  FutureOr<void> _loginWithGoogleEvent(
      LoginWithGoogleEvent event, Emitter<LoginState> emit) async {
    try {
      emit(
        LoginLoading(
          state.data,
        ),
      );
      final signInAccount = await _googleSignIn.signIn();
      if (signInAccount == null) {
        emit(
          LoginWithGoogleFailed(
            state.data.copyWith(
              error: 'login_with_google_failed',
            ),
          ),
        );
        return;
      }
      final googleSignInAuthentication = await signInAccount.authentication;
      final credentials = await FirebaseAuth.instance.signInWithCredential(
        GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        ),
      );
      final tokenId = await credentials.user?.getIdToken();
      await credentials.user?.delete();
      await _googleSignIn.signOut();
      final res = await _socialLogin(
        tokenId ?? '',
      );
      res.fold(
        (l) {
          emit(
            LoginWithGoogleFailed(
              state.data.copyWith(
                error: l.message,
              ),
            ),
          );
        },
        (r) {
          emit(
            LoginSuccess(
              state.data,
            ),
          );
        },
      );
    } on ApiFailure catch (e) {
      emit(
        LoginWithGoogleFailed(
          state.data.copyWith(
            error: e.message,
          ),
        ),
      );
    } catch (e) {
      emit(
        LoginWithGoogleFailed(
          state.data.copyWith(
            error: e.toString(),
          ),
        ),
      );
    }
  }
}
