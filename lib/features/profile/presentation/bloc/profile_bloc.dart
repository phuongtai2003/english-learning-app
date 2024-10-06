import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:final_flashcard/core/errors/failure.dart';
import 'package:final_flashcard/features/profile/domain/entities/profile.dart';
import 'package:final_flashcard/features/profile/domain/use_case/change_dark_mode.dart';
import 'package:final_flashcard/features/profile/domain/use_case/change_language.dart';
import 'package:final_flashcard/features/profile/domain/use_case/change_name.dart';
import 'package:final_flashcard/features/profile/domain/use_case/change_password.dart';
import 'package:final_flashcard/features/profile/domain/use_case/change_push_notification.dart';
import 'package:final_flashcard/features/profile/domain/use_case/change_save_offline.dart';
import 'package:final_flashcard/features/profile/domain/use_case/get_profile.dart';
import 'package:final_flashcard/features/profile/domain/use_case/logout.dart';
import 'package:final_flashcard/features/profile/domain/use_case/pick_profile_image.dart';
import 'package:final_flashcard/features/profile/domain/use_case/send_otp_new_email.dart';
import 'package:final_flashcard/features/profile/domain/use_case/verify_new_email.dart';
import 'package:final_flashcard/features/profile/domain/use_case/verify_password.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_event.dart';
part 'profile_state.dart';
part 'profile_bloc.freezed.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final Logout _logout;
  final ChangeDarkMode _changeDarkMode;
  final GetProfile _getProfile;
  final ChangeLanguage _changeLanguage;
  final ChangePushNotification _changePushNotification;
  final ChangeSaveOffline _changeSaveOffline;
  final PickProfileImage _pickProfileImage;
  final ChangeNameUseCase _changeNameUseCase;
  final VerifyPasswordUseCase _verifyPasswordUseCase;
  final SendOtpNewEmailUseCase _sendOtpNewEmailUseCase;
  final VerifyNewEmailUseCase _verifyNewEmailUseCase;
  final ChangePasswordUseCase _changePasswordUseCase;
  final Connectivity _connectivity;
  ProfileBloc(
    this._logout,
    this._changeDarkMode,
    this._getProfile,
    this._changeLanguage,
    this._changePushNotification,
    this._changeSaveOffline,
    this._pickProfileImage,
    this._changeNameUseCase,
    this._verifyPasswordUseCase,
    this._sendOtpNewEmailUseCase,
    this._verifyNewEmailUseCase,
    this._changePasswordUseCase,
    this._connectivity,
  ) : super(const ProfileState.initial(ProfileStateData())) {
    on<ProfileGetProfileEvent>(_onGetProfile);
    on<ProfileLogoutEvent>(_onLogout);
    on<ProfileChangeDarkModeEvent>(_onChangeDarkMode);
    on<ProfileChangeLanguageEvent>(_onChangeLanguage);
    on<ProfileChangePushNotificationEvent>(_onChangePushNotification);
    on<ProfileChangeSaveSetsEvent>(_onChangeSaveSets);
    on<ProfilePickImageEvent>(_onPickImage);
    on<ProfileChangeNameEvent>(_onChangeName);
    on<ProfileVerifyPasswordEvent>(_onVerifyPassword);
    on<ProfileSendOtpNewEmailEvent>(_onSendOtpNewEmail);
    on<ProfileVerifyNewEmailEvent>(_onVerifyNewEmail);
    on<ProfileChangePasswordEvent>(_onChangePassword);
    _connectivity.onConnectivityChanged.listen(_onConnectivityChanged);
  }

  void _onChangePassword(
      ProfileChangePasswordEvent event, Emitter<ProfileState> emit) async {
    emit(
      ProfileChangePasswordLoading(
        state.data,
      ),
    );
    final result = await _changePasswordUseCase(
      ChangePasswordParams(
        oldPassword: event.oldPassword,
        newPassword: event.newPassword,
      ),
    );
    result.fold(
      (failure) {
        emit(
          ProfileChangePasswordError(
            state.data.copyWith(
              error: failure.message,
            ),
          ),
        );
      },
      (success) {
        emit(
          ProfileChangePasswordSuccess(
            state.data,
          ),
        );
      },
    );
  }

  void _onVerifyNewEmail(
      ProfileVerifyNewEmailEvent event, Emitter<ProfileState> emit) async {
    emit(
      ProfileVerifyNewEmailSuccess(
        state.data,
      ),
    );
    final result = await _verifyNewEmailUseCase(
      VerifyNewEmailParams(
        email: event.email,
        otp: event.otp,
      ),
    );
    result.fold(
      (failure) {
        emit(
          ProfileVerifyNewEmailError(
            state.data.copyWith(
              error: failure.message,
            ),
          ),
        );
      },
      (email) {
        emit(
          ProfileVerifyNewEmailSuccess(
            state.data,
          ),
        );
      },
    );
  }

  void _onSendOtpNewEmail(
      ProfileSendOtpNewEmailEvent event, Emitter<ProfileState> emit) async {
    emit(
      ProfileSendOtpNewEmailLoading(
        state.data,
      ),
    );
    final result = await _sendOtpNewEmailUseCase(event.email);
    result.fold(
      (failure) {
        emit(
          ProfileSendOtpNewEmailError(
            state.data.copyWith(
              error: failure.message,
            ),
          ),
        );
      },
      (success) {
        emit(
          ProfileSendOtpNewEmailSuccess(
            state.data,
          ),
        );
      },
    );
  }

  void _onVerifyPassword(
      ProfileVerifyPasswordEvent event, Emitter<ProfileState> emit) async {
    emit(
      ProfileVerifyPasswordLoading(
        state.data,
      ),
    );
    final result = await _verifyPasswordUseCase(event.password);
    result.fold(
      (failure) {
        emit(
          ProfileVerifyPasswordError(
            state.data.copyWith(
              error: failure.message,
            ),
          ),
        );
      },
      (success) {
        emit(
          ProfileVerifyPasswordSuccess(
            state.data,
          ),
        );
      },
    );
  }

  void _onChangeName(
      ProfileChangeNameEvent event, Emitter<ProfileState> emit) async {
    emit(
      ProfileChangeNameLoading(
        state.data,
      ),
    );
    final result = await _changeNameUseCase(event.name);
    result.fold(
      (failure) {
        emit(
          ProfileChangeNameError(
            state.data.copyWith(
              error: failure.message,
            ),
          ),
        );
      },
      (profile) {
        emit(
          ProfileChangeNameSuccess(
            state.data.copyWith(
              profile: profile,
            ),
          ),
        );
      },
    );
  }

  void _onLogout(ProfileLogoutEvent event, Emitter<ProfileState> emit) async {
    try {
      await _logout();
      emit(
        ProfileLogout(state.data),
      );
    } on CacheFailure catch (e) {
      emit(
        ProfileError(
          state.data.copyWith(
            error: e.message,
          ),
        ),
      );
    } catch (e) {
      emit(
        ProfileError(
          state.data.copyWith(
            error: e.toString(),
          ),
        ),
      );
    }
  }

  void _onChangeDarkMode(
      ProfileChangeDarkModeEvent event, Emitter<ProfileState> emit) async {
    try {
      await _changeDarkMode(event.darkMode);
      final profile = state.data.profile?.copyWith(
        darkMode: event.darkMode,
      );
      emit(
        ProfileChangeDarkMode(
          state.data.copyWith(
            profile: profile,
          ),
        ),
      );
    } on CacheFailure catch (e) {
      emit(
        ProfileError(
          state.data.copyWith(
            error: e.message,
          ),
        ),
      );
    } catch (e) {
      emit(
        ProfileError(
          state.data.copyWith(
            error: e.toString(),
          ),
        ),
      );
    }
  }

  void _onGetProfile(
      ProfileGetProfileEvent event, Emitter<ProfileState> emit) async {
    try {
      emit(
        ProfileLoading(
          state.data,
        ),
      );
      final result = await _getProfile();
      result.fold(
        (failure) {
          emit(
            ProfileError(
              state.data.copyWith(
                error: failure.message,
              ),
            ),
          );
        },
        (profile) {
          emit(
            ProfileLoaded(
              state.data.copyWith(
                profile: profile,
              ),
            ),
          );
        },
      );
    } on ApiFailure catch (e) {
      emit(
        ProfileError(
          state.data.copyWith(
            error: e.message,
          ),
        ),
      );
    } catch (e) {
      emit(
        ProfileError(
          state.data.copyWith(
            error: e.toString(),
          ),
        ),
      );
    }
  }

  void _onChangeLanguage(
      ProfileChangeLanguageEvent event, Emitter<ProfileState> emit) async {
    try {
      await _changeLanguage(event.language);
      final profile = state.data.profile?.copyWith(
        language: event.language,
      );
      emit(
        ProfileChangeLanguage(
          state.data.copyWith(
            profile: profile,
          ),
        ),
      );
    } on CacheFailure catch (e) {
      emit(
        ProfileError(
          state.data.copyWith(
            error: e.message,
          ),
        ),
      );
    } catch (e) {
      emit(
        ProfileError(
          state.data.copyWith(
            error: e.toString(),
          ),
        ),
      );
    }
  }

  void _onChangePushNotification(ProfileChangePushNotificationEvent event,
      Emitter<ProfileState> emit) async {
    try {
      final res = await _changePushNotification(event.pushNotification);
      res.fold(
        (failure) {
          emit(
            ProfileError(
              state.data.copyWith(
                error: failure.message,
              ),
            ),
          );
        },
        (success) {
          final profile = state.data.profile?.copyWith(
            pushNotification: success,
          );
          emit(
            ProfileChangePushNotification(
              state.data.copyWith(
                profile: profile,
              ),
            ),
          );
        },
      );
    } on ApiFailure catch (e) {
      emit(
        ProfileError(
          state.data.copyWith(
            error: e.message,
          ),
        ),
      );
    } catch (e) {
      emit(
        ProfileError(
          state.data.copyWith(
            error: e.toString(),
          ),
        ),
      );
    }
  }

  void _onChangeSaveSets(
      ProfileChangeSaveSetsEvent event, Emitter<ProfileState> emit) async {
    try {
      final res = await _changeSaveOffline(event.saveSets);
      res.fold(
        (failure) {
          emit(
            ProfileError(
              state.data.copyWith(
                error: failure.message,
              ),
            ),
          );
        },
        (result) {
          final profile = state.data.profile?.copyWith(
            saveSets: result,
          );
          emit(
            ProfileChangeSaveSets(
              state.data.copyWith(
                profile: profile,
              ),
            ),
          );
        },
      );
    } on ApiFailure catch (e) {
      emit(
        ProfileError(
          state.data.copyWith(
            error: e.message,
          ),
        ),
      );
    } catch (e) {
      emit(
        ProfileError(
          state.data.copyWith(
            error: e.toString(),
          ),
        ),
      );
    }
  }

  void _onPickImage(
      ProfilePickImageEvent event, Emitter<ProfileState> emit) async {
    try {
      emit(
        ProfileLoading(
          state.data,
        ),
      );
      final response = await _pickProfileImage(event.image);
      response.fold(
        (l) {
          emit(
            ProfileError(
              state.data.copyWith(
                error: l.message,
              ),
            ),
          );
        },
        (r) {
          final profile = state.data.profile?.copyWith(
            image: r,
          );
          emit(
            ProfilePickImage(
              state.data.copyWith(
                profile: profile,
              ),
            ),
          );
        },
      );
    } catch (e) {
      emit(
        ProfileError(
          state.data.copyWith(
            error: e.toString(),
          ),
        ),
      );
    }
  }

  void _onConnectivityChanged(List<ConnectivityResult> event) {
    add(const ProfileGetProfileEvent());
  }
}
