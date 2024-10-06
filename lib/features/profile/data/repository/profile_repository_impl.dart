import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/core/errors/failure.dart';
import 'package:final_flashcard/features/profile/data/data_source/profile_local_data_source.dart';
import 'package:final_flashcard/features/profile/data/data_source/profile_remote_data_source.dart';
import 'package:final_flashcard/features/profile/data/model/change_email_request.dart';
import 'package:final_flashcard/features/profile/data/model/change_name_request.dart';
import 'package:final_flashcard/features/profile/data/model/change_password_request.dart';
import 'package:final_flashcard/features/profile/data/model/profile_model.dart';
import 'package:final_flashcard/features/profile/data/model/send_otp_new_email_request.dart';
import 'package:final_flashcard/features/profile/data/model/verify_password_request.dart';
import 'package:final_flashcard/features/profile/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource _profileLocalDataSource;
  final ProfileRemoteDataSource _profileRemoteDataSource;

  const ProfileRepositoryImpl(
      this._profileLocalDataSource, this._profileRemoteDataSource);

  @override
  ResultVoid logout() async {
    try {
      await _profileLocalDataSource.logout();
      return const Right(null);
    } catch (e) {
      return Left(
        CacheFailure(
          statusCode: 500,
          message: e.toString(),
        ),
      );
    }
  }

  @override
  ResultFuture<void> changeDarkMode(bool darkMode) async {
    try {
      await _profileLocalDataSource.changeDarkMode(darkMode);
      return const Right(null);
    } catch (e) {
      return Left(
        CacheFailure(
          statusCode: 500,
          message: e.toString(),
        ),
      );
    }
  }

  @override
  ResultFuture<ProfileModel> getProfile() async {
    final cachedProfile = await _profileLocalDataSource.getLocalUser();
    try {
      final profile = await _profileRemoteDataSource.getProfile();
      if (profile.data == null) {
        return Right(cachedProfile);
      } else {
        final data = profile.data!;
        final config = await _profileLocalDataSource.getConfig();
        return Right(
          ProfileModel(
            id: data.id,
            email: data.email,
            name: data.name,
            dateOfBirth: data.dateOfBirth,
            darkMode: config.darkMode,
            language: config.language,
            pushNotification: data.pushNotification,
            saveSets: data.saveSets,
            image: data.image,
          ),
        );
      }
    } catch (e) {
      return Right(cachedProfile);
    }
  }

  @override
  ResultVoid changeLanguage(String language) async {
    try {
      await _profileLocalDataSource.changeLanguage(language);
      return const Right(null);
    } catch (e) {
      return Left(
        CacheFailure(
          statusCode: 500,
          message: e.toString(),
        ),
      );
    }
  }

  @override
  ResultFuture<bool> changePushNotification(bool pushNotification) async {
    try {
      final res = await _profileRemoteDataSource
          .updatePushNotification(pushNotification);
      return Right(res);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: 'something_went_wrong',
          statusCode: e.response!.statusCode!,
        ),
      );
    } catch (e) {
      return Left(
        ApiFailure(
          statusCode: 500,
          message: e.toString(),
        ),
      );
    }
  }

  @override
  ResultFuture<bool> changeSaveOffline(bool saveOffline) async {
    try {
      final res = await _profileRemoteDataSource.updateSaveOffline(saveOffline);
      return Right(res);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: 'something_went_wrong',
          statusCode: e.response!.statusCode!,
        ),
      );
    } catch (e) {
      return Left(
        CacheFailure(
          statusCode: 500,
          message: e.toString(),
        ),
      );
    }
  }

  @override
  ResultFuture<String> pickProfileImage(File image) async {
    try {
      final url = await _profileRemoteDataSource.updateImage(image);
      return Right(url);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response!.data['data'],
          statusCode: e.response!.statusCode!,
        ),
      );
    } catch (e) {
      return Left(
        ApiFailure(
          statusCode: 500,
          message: e.toString(),
        ),
      );
    }
  }

  @override
  ResultFuture<ProfileModel> changeName(String name) async {
    try {
      final profile = await _profileRemoteDataSource.changeName(
        request: ChangeNameRequest(name: name),
      );
      final config = await _profileLocalDataSource.getConfig();
      return Right(
        ProfileModel(
          id: profile.data!.id,
          email: profile.data!.email,
          name: profile.data!.name,
          dateOfBirth: profile.data!.dateOfBirth,
          darkMode: config.darkMode,
          language: config.language,
          pushNotification: profile.data!.pushNotification,
          saveSets: profile.data!.saveSets,
          image: profile.data!.image,
        ),
      );
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: 'something_went_wrong',
          statusCode: e.response!.statusCode ?? 500,
        ),
      );
    } catch (e) {
      return const Left(
        ApiFailure(
          statusCode: 500,
          message: 'something_went_wrong',
        ),
      );
    }
  }

  @override
  ResultFuture<bool> verifyPassword(String password) async {
    try {
      final res = await _profileRemoteDataSource.verifyPassword(
        request: VerifyPasswordRequest(password: password),
      );
      return Right(res);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: 'something_went_wrong',
          statusCode: e.response!.statusCode ?? 500,
        ),
      );
    } catch (e) {
      return Left(
        ApiFailure(
          statusCode: 500,
          message: e.toString(),
        ),
      );
    }
  }

  @override
  ResultFuture<bool> sendOtpNewEmail(String email) async {
    try {
      final res = await _profileRemoteDataSource.sendOtpNewEmail(
        request: SendOtpNewEmailRequest(
          newEmail: email,
        ),
      );
      return Right(res);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: 'something_went_wrong',
          statusCode: e.response!.statusCode ?? 500,
        ),
      );
    } catch (e) {
      return Left(
        ApiFailure(
          statusCode: 500,
          message: e.toString(),
        ),
      );
    }
  }

  @override
  ResultFuture<String> changeEmail(String email, String otp) async {
    try {
      final res = await _profileRemoteDataSource.changeEmail(
        request: ChangeEmailRequest(
          newEmail: email,
          otp: otp,
        ),
      );
      await _profileLocalDataSource.saveToken(res);
      return Right(res);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: 'something_went_wrong',
          statusCode: e.response!.statusCode ?? 500,
        ),
      );
    } catch (e) {
      return Left(
        ApiFailure(
          statusCode: 500,
          message: e.toString(),
        ),
      );
    }
  }

  @override
  ResultFuture<bool> changePassword(
      String oldPassword, String newPassword) async {
    try {
      final res = await _profileRemoteDataSource.changePassword(
        request: ChangePasswordRequest(
          oldPassword: oldPassword,
          newPassword: newPassword,
        ),
      );
      return Right(res);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: 'something_went_wrong',
          statusCode: e.response!.statusCode ?? 500,
        ),
      );
    } catch (e) {
      return Left(
        ApiFailure(
          statusCode: 500,
          message: e.toString(),
        ),
      );
    }
  }
}
